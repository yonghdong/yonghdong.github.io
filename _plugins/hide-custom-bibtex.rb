module Jekyll
  module HideCustomBibtex
    def hideCustomBibtex(input)
	    keywords = @context.registers[:site].config['filtered_bibtex_keywords']

	    keywords.each do |keyword|
		    input = input.gsub(/^.*\b#{keyword}\b *= *\{.*$\n/, '')
	    end

      # Clean superscripts in author lists
      input = input.gsub(/^.*\bauthor\b *= *\{.*$\n/) { |line| line.gsub(/[*†‡§¶‖&^]/, '') }

      # Print author names as "First Last" instead of jekyll-scholar's "Last, First"
      input = input.gsub(/^(\s*author\s*=\s*\{)(.*)(\},?\s*)$/) do
        prefix, names, suffix = Regexp.last_match(1), Regexp.last_match(2), Regexp.last_match(3)
        names = names.split(/\s+and\s+/).map do |name|
          parts = name.split(/\s*,\s*/)
          parts.length == 2 ? "#{parts[1]} #{parts[0]}" : name
        end
        "#{prefix}#{names.join(' and ')}#{suffix}"
      end

      return input
    end
  end
end

Liquid::Template.register_filter(Jekyll::HideCustomBibtex)
