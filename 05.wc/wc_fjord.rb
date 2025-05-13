#!/usr/bin/env ruby

require 'optparse'

class OptionParserHandler
  attr_reader :options

  def initialize
    @options = { lines: false, words: false, bytes: false }
    parse_options
  end

  private

  def parse_options
    OptionParser.new do |opts|
      opts.on('-l', '--lines') { @options[:lines] = true }
      opts.on('-w', '--words') { @options[:words] = true }
      opts.on('-c', '--bytes') { @options[:bytes] = true }
    end.parse!

    @options.transform_values! { true } if @options.values.none?
  end
end

class FileContentReader
  attr_reader :files, :stdin_mode

  def initialize
    @files = ARGV.empty? ? [] : ARGV
    @stdin_mode = @files.empty?
  end

  def read_contents
    return { 'nil' => $stdin.read } if @stdin_mode

    @files.each_with_object({}) do |filename, hash|
      hash[filename] = File.read(filename)
    rescue Errno::ENOENT
      warn "wc_fjord.rb: #{filename}: No such file or directory"
    rescue Errno::EACCES
      warn "wc_fjord.rb: #{filename}: Permission denied"
    end
  end
end

class TextAnalyzer
  def initialize(text)
    @text = text
  end

  def count_lines
    @text.lines.count
  end

  def count_words
    @text.split(/\s+/).count { |w| !w.empty? }
  end

  def count_bytes
    @text.bytesize
  end
end

class WcFormatter
  def initialize(results_text_analyzed, options, stdin_mode)
    @results_text_analyzed = results_text_analyzed
    @options = options
    @stdin_mode = stdin_mode
  end

  def display_result
    total = Hash.new(0)

    @results_text_analyzed.each do |filename, counts|
      accumulate_total(total, counts)
      print_result(counts, filename)
    end

    return unless @results_text_analyzed.size > 1 && !@stdin_mode

    print_result(total, 'total')
  end

  private

  def accumulate_total(total, counts)
    total[:lines] += counts[:lines]
    total[:words] += counts[:words]
    total[:bytes] += counts[:bytes]
  end

  def print_result(counts, filename)
    fields = []
    fields << counts[:lines].to_s.rjust(4) if @options[:lines]
    fields << counts[:words].to_s.rjust(4) if @options[:words]
    fields << counts[:bytes].to_s.rjust(4) if @options[:bytes]
    fields << filename if filename != 'nil'
    puts fields.join(' ')
  end
end

def main
  options_handler = OptionParserHandler.new.options
  file_content_reader = FileContentReader.new
  imported_contents = file_content_reader.read_contents

  results_text_analyzed = imported_contents.transform_values do |text|
    text_analyzer = TextAnalyzer.new(text)
    {
      lines: text_analyzer.count_lines,
      words: text_analyzer.count_words,
      bytes: text_analyzer.count_bytes
    }
  end

  results_wc_format = WcFormatter.new(results_text_analyzed, options_handler, file_content_reader.stdin_mode)
  results_wc_format.display_result
end

main if $PROGRAM_NAME == __FILE__
