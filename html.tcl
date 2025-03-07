proc html {tag args} {
	global wapp

	# Normalize Implicit Script
	if {[llength $args] % 2 == 1} {
		set args [linsert $args end-1 body]
	}

	# Generate Attributes String
	set attributes {}
	foreach {name value} $args {
		switch $name {
			{html} {}
			{text} {}
			{body} {}
			{default} {
				# Collapse Whitespace
				set value [regsub -all {\s+} $value { }]
				# Escape Quotes
				set value [string map {\" &quot;} $value]
				# Trim Whitespace
				set value [string trim $value]
				# Skip Empty Attributes
				if {$value == {}} {
					continue
				}
				# Append Attribute
				set attributes [format {%s %s="%s"} $attributes $name $value]
			}
		}
	}

	# Append Opening Tag
	switch $tag {
		{} {}
		{default} {
			# Maybe Append Newline
			switch [string index [dict get $wapp .reply] end] {
				{} {}
				\n {}
				default {
					dict append wapp .reply \n
				}
			}
			# Append the actual Tag
			dict append wapp .reply <$tag$attributes>
		}
	}
	# Process Special Attributes
	foreach {name value} $args {
		switch $name {
			{html} { dict append wapp .reply $value }
			{text} { dict append wapp .reply [string map {< &lt;} $value] }
			{body} { uplevel 1 $value }
		}
	}
	# Append Closing Tag
	switch $tag {
		{} {}
		{area} {}
		{base} {}
		{br} {}
		{col} {}
		{embed} {}
		{hr} {}
		{img} {}
		{input} {}
		{link} {}
		{meta} {}
		{param} {}
		{source} {}
		{track} {}
		{wbr} {}
		{default} {
			dict append wapp .reply </$tag>\n
		}
	}
}

