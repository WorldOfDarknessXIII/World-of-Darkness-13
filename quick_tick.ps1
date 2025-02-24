$json_info = Get-Content .\tools\ticked_file_enforcement\schemas\tgstation_dme.json -raw
$json_info | py .\tools\ticked_file_enforcement\ticked_file_enforcement.py > tick_check.log
code tick_check.log
