{
	"identifier": "file_template",
	"title": "File management Template",
	"help": "Append sample content to a file on your user workspace.",
	"publisher": "file",
	"payload": {
		"method": "append",
		"uri": "i2x_log.csv",
		"content": "${i2x.datetime},%{variant},%{locus},%{refseq}\n"
	}
}