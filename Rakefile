desc 'Trim whitespace'
task :trim do
  awk_statement = <<-AWK
   {
     if ($1 == "RM" || $1 == "R") {
       print $4;
     } else if ($1 != "D") {
       if ($2 ~ /\".*/) {
	 print $2 "\\\\ " $3;
       } else {
         print $2;
       }
     }
   }
  AWK

  awk_statement.gsub!(%r{\s+}, " ")
  success = system(%Q[git status --porcelain | awk '#{awk_statement}' | sed 's/\"//g' | grep --include=*.{swift,h,c,m,mm} ./ | xargs sed -i '' -e 's/ *$//g;'])
  unless success
    exit 1
  end
end
