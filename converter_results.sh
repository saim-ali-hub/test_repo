#!/bin/bash

# Input and output files
RESULT_FILE="/tmp/.systemdir/table/linux_test_results_table.txt"
HTML_FILE="/var/www/html/result/linux_test_results_table.html"
TMP_SORTED=$(mktemp)

# Extract heading safely (remove leading/trailing spaces)
TEST_TITLE=$(head -n 1 "$RESULT_FILE" | xargs)

# Sort results by percentage (descending)
tail -n +5 "$RESULT_FILE" | \
    awk '{ gsub("%","",$6); print }' | sort -k6,6nr > "$TMP_SORTED"

{
echo "<!DOCTYPE html>"
echo "<html lang='en'>"
echo "<head>"
echo "  <meta charset='UTF-8'>"
echo "  <meta http-equiv='refresh' content='30'>"
echo "  <title>$TEST_TITLE</title>"
echo "  <style>"
echo "      body {"
echo "          margin: 0;"
echo "          font-family: Arial, sans-serif;"
echo "          color: #f0f0f0;"
echo "          background-color: #2b2b2b;"
echo "      }"
echo "      h2 { text-align: center; color: #00ffcc; margin-top: 20px; }"
echo "      table { border-collapse: collapse; width: 95%; margin: 20px auto; box-shadow: 0px 0px 15px #000; }"
echo "      th, td { border: 1px solid #444; padding: 10px; text-align: center; }"
echo "      th { background-color: #333; color: #00ffcc; }"
echo "      tr:nth-child(even) { background-color: #3a3a3a; }"
echo "      tr:nth-child(odd)  { background-color: #2b2b2b; }"
echo "      tr:hover { background-color: #444; }"
echo "  </style>"
echo "</head>"
echo "<body>"
echo "  <h2>$TEST_TITLE</h2>"
echo "  <table>"
echo "    <tr>"
echo "      <th>Sr.#</th><th>Username</th><th>Date</th><th>Total</th><th>Passed</th><th>Percentage</th>"
echo "      <th>Section2</th><th>Section3</th><th>Section4</th><th>Section5</th><th>Section6</th>"
echo "    </tr>"
} > "$HTML_FILE"

# Add sorted data into table with renumbered Sr.#
awk 'BEGIN {OFS="</td><td>"}
    {
        sr=NR
        print "    <tr><td>" sr, $2, $3, $4, $5, $6"%", $7, $8, $9, $10, $11 "</td></tr>"
    }' "$TMP_SORTED" >> "$HTML_FILE"

{
echo "  </table>"
echo "</body>"
echo "</html>"
} >> "$HTML_FILE"

rm -f "$TMP_SORTED"
