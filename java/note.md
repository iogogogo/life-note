# 命令行拆分成string数组

Java 实现:[split-a-string-containing-command-line-parameters-into-a-string-in-java](https://stackoverflow.com/questions/3259143/split-a-string-containing-command-line-parameters-into-a-string-in-java#)

ant jar:[ant](https://mvnrepository.com/artifact/org.apache.ant/ant)

scala 实现:直接使用scala.tools.cmd提供的api


```shell
-p /path -d "here's my description" --verbose other args
```

```
Array[0] = -p
Array[1] = /path
Array[2] = -d
Array[3] = here's my description
Array[4] = --verbose
Array[5] = other
Array[6] = args
```

解决方案

```java
/**
 * [code borrowed from ant.jar]
 * Crack a command line.
 * @param toProcess the command line to process.
 * @return the command line broken into strings.
 * An empty or null toProcess parameter results in a zero sized array.
 */
public static String[] translateCommandline(String toProcess) {
    if (toProcess == null || toProcess.length() == 0) {
        //no command? no string
        return new String[0];
    }
    // parse with a simple finite state machine

    final int normal = 0;
    final int inQuote = 1;
    final int inDoubleQuote = 2;
    int state = normal;
    final StringTokenizer tok = new StringTokenizer(toProcess, "\"\' ", true);
    final ArrayList<String> result = new ArrayList<String>();
    final StringBuilder current = new StringBuilder();
    boolean lastTokenHasBeenQuoted = false;

    while (tok.hasMoreTokens()) {
        String nextTok = tok.nextToken();
        switch (state) {
        case inQuote:
            if ("\'".equals(nextTok)) {
                lastTokenHasBeenQuoted = true;
                state = normal;
            } else {
                current.append(nextTok);
            }
            break;
        case inDoubleQuote:
            if ("\"".equals(nextTok)) {
                lastTokenHasBeenQuoted = true;
                state = normal;
            } else {
                current.append(nextTok);
            }
            break;
        default:
            if ("\'".equals(nextTok)) {
                state = inQuote;
            } else if ("\"".equals(nextTok)) {
                state = inDoubleQuote;
            } else if (" ".equals(nextTok)) {
                if (lastTokenHasBeenQuoted || current.length() != 0) {
                    result.add(current.toString());
                    current.setLength(0);
                }
            } else {
                current.append(nextTok);
            }
            lastTokenHasBeenQuoted = false;
            break;
        }
    }
    if (lastTokenHasBeenQuoted || current.length() != 0) {
        result.add(current.toString());
    }
    if (state == inQuote || state == inDoubleQuote) {
        throw new RuntimeException("unbalanced quotes in " + toProcess);
    }
    return result.toArray(new String[result.size()]);
}
```

# 读取resource目录下的properties文件

```java
InputStream stream = ClassLoader.getSystemResourceAsStream("xxx.properties");
BufferedReader reader = new BufferedReader(new InputStreamReader(stream));
Properties properties = new Properties();
properties.load(reader);
System.out.println(properties.getProperty("xxx.name", "123"));
```

