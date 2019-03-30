package RestfulTest;

import com.fasterxml.jackson.core.Version;
import com.fasterxml.jackson.databind.Module;
//import net.bigpoint.jackson.databind.introspect.JacksonLegacyIntrospector;

public class Jackson1CompatibilityModule extends Module {

    @Override public String getModuleName() {
        return "Jackson1CompatibilitySupport";
    }

    @Override public Version version() {
        return new Version(1, 0, 0, "", "net.bigpoint.jackson", "JacksonLegacySupport");
    }

    @Override public void setupModule(SetupContext context) {
//        context.appendAnnotationIntrospector(new JacksonLegacyIntrospector());
    }
}
