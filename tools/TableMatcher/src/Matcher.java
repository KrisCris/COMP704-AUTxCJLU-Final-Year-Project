import java.io.*;
import java.util.ArrayList;

public class Matcher {
    private ArrayList<String>[] tables;
    private ArrayList<String> newTable;

    public Matcher(String inPathMinor, String inPathMajor) throws Exception {
        String[] paths = {inPathMinor, inPathMajor};
        this.newTable = new ArrayList<>();
        this.tables = new ArrayList[2];
        int table = 0;
        for (String p : paths) {
            BufferedReader reader = new BufferedReader(new FileReader(p));
            String line;
            this.tables[table] = new ArrayList<>();
            while ((line = reader.readLine()) != null) {
                this.tables[table].add(line);
            }
            reader.close();
            table++;
        }
    }

    public ArrayList<String> match() {
        for (String s : this.tables[0]) {
            int commaAt = s.indexOf(',');
            String sub = s.substring(commaAt);
            boolean flag = false;
            for (String t: this.tables[1]){
                if (t.contains(sub)){
                    if (s.charAt(s.length()-1) == ','){
                        s = s + t;
                    } else {
                        s = s + ',' + t;
                    }
                    this.newTable.add(s);
                    flag = true;
                    break;
                }
            }
            if(!flag){
                this.newTable.add(s);
            }

        }
        return newTable;
    }

    public void write(String outPath) throws Exception{
        BufferedWriter writer = new BufferedWriter(new FileWriter(outPath));
        for (String s: this.newTable){
            writer.write(s);
            writer.newLine();
        }
        writer.flush();
        writer.close();
    }

    public static void main(String[] args) throws Exception {
        Matcher matcher = new Matcher(
                "/Users/kriscris/Downloads/custom_dataset.csv",
                "/Users/kriscris/Downloads/hiyd_detail.csv"
        );
        matcher.match();
        matcher.write("/Users/kriscris/Downloads/new.csv");
    }
}
