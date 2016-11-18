name := "direct_kafka_word_count"

scalaVersion := "2.10.5"

val sparkVersion = "1.6.1"

libraryDependencies ++= Seq(
  "org.apache.spark" %% "spark-core" % sparkVersion % "provided",
  "org.apache.spark" %% "spark-streaming" % sparkVersion % "provided",
  ("org.apache.spark" %% "spark-streaming-kafka" % sparkVersion) exclude ("org.spark-project.spark", "unused"),
  "org.apache.spark" % "spark-sql_2.10" % "1.6.1" % "provided"
)

assemblyJarName in assembly := name.value + ".jar"
