package data

import java.io.File
import java.sql.Connection

import com.mysema.query.sql.codegen.MetaDataExporter

object DBModelGen {

  val conn_str = "jdbc:mysql://127.0.0.1:3307/db_example?useUnicode=true&user=springuser&password=ThePassword"
  var conn: Connection = _

  def main(args: Array[String]): Unit = {
    conn = classOf[com.mysql.jdbc.Driver].newInstance().connect(conn_str, null);

    val exporter = new MetaDataExporter();
    exporter.setPackageName("com.wb.domain.user.model");
    exporter.setTargetFolder(new File("src/main/java"));
    exporter.setBeanPrefix("S")
    exporter.export(conn.getMetaData());
    conn.close
  }

}