package hdf5;

import ucar.nc2.Attribute;
import ucar.nc2.Group;
import ucar.nc2.NetcdfFile;
import ucar.nc2.Variable;
import ucar.nc2.iosp.hdf5.H5iosp;
import ucar.nc2.util.DebugFlags;

import java.io.IOException;

/**
 * Example class to read a HDF5 file and dump some of the contained metadata.
 */
public class HDF5Test {
    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("Usage: java HDF5Test file.h5");
            return;
        }
        enableFullDebugging();
        NetcdfFile dataFile = null;
        try {
            dataFile = NetcdfFile.open(args[0]);
            Group rootGroup = dataFile.getRootGroup();
            System.out.println(printAttributes(rootGroup));
        } catch (Exception e) {
            e.printStackTrace(System.err);
        } finally {
            if (dataFile != null) {
                try {
                    dataFile.close();
                } catch (IOException e) {
                    e.printStackTrace(System.err);
                }
            }
        }
    }

    private static String printAttributes(Group group) {
        StringBuilder sb = new StringBuilder();
        printAttributes(group, 0, sb);
        return sb.toString();
    }

    private static void printAttributes(Group group, int indent, StringBuilder sb) {
        indent(sb, indent);
        sb.append("Group [");
        sb.append(group.getName());
        sb.append("]\n");
        for (Variable variable: group.getVariables()) {
            indent(sb, indent + 2);
            sb.append("V ");
            sb.append(variable.getName());
            sb.append(" (");
            sb.append(variable.getDescription());
            sb.append(") ");
            sb.append(variable.getDimensionsString());
            sb.append(" ");
            sb.append(variable.getDataType());
            sb.append("\n");

        }
        for (Attribute attribute: group.getAttributes()) {
            indent(sb, indent + 2);
            sb.append("A ");
            sb.append(attribute.getName());
            sb.append("=");
            if (attribute.getDataType().isNumeric()) {
                sb.append(attribute.getNumericValue());
            } else {
                sb.append(attribute.getStringValue());
            }
            sb.append("\n");
        }
        for (Group subgroup: group.getGroups()) {
            printAttributes(subgroup, indent + 4, sb);
        }
    }

    private static void indent(StringBuilder sb, int indent) {
        for (int i = 0; i < indent; ++i) {
            sb.append(" ");
        }
    }

    private static void enableFullDebugging() {
        H5iosp.setDebugFlags(new DebugFlags() {
            @Override public void set(String flagName, boolean value) {} //ignore
            @Override public boolean isSet(String flagName) {
                return true;
            }
        });
    }
}