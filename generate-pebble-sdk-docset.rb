require 'json'

SearchIndexPath = 'Pebble.docset/Contents/Resources/Documents/search/'
Mapping = [['Class', 'classes'], ['Function', 'functions'], ['Enum', 'enums'], ['Literal', 'enumvalues'], ['Module', 'groups'], ['Type', 'typedefs']]

def print_create_table
  puts "DROP TABLE IF EXISTS searchIndex;"
  puts "CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);"
  puts "CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);"
end

def print_insert(name, path, type)
  puts "INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES ('#{name}', '#{type}', '#{path}');"
end

def parse_entries_recursive(entries)
  entries.each do |entry_array|
    print_insert(entry_array[0], 'function', entry_array[1])
    parse_entries_recursive(entry_array[2]) if (entry_array[2].class == Array)
  end
end

def main
  print_create_table()
  json_from_js = Regexp.compile(/\s*var\s*\w+\s*\=\s*(.+);\s*$/m)
  Mapping.each do |doc_type, file_pattern|
    Dir.glob(SearchIndexPath + file_pattern + "_*.js") do |filename|
      begin
        candidate_json_matches = json_from_js.match(File.read(filename))
        json_text = candidate_json_matches.captures.first
        json_text.gsub!("'", '"')
        search_entries = JSON.parse(json_text)
        search_entries.each do |arr|
          arr.flatten!
          print_insert(arr[1], arr[2].sub('../', ''), doc_type)
        end
      end
    end  
  end
end

main if __FILE__ == $0