require "activesniper/version"
require "active_record"

module ActiveSniper
  def before_save_snipe(*args, &block)
    if extractable_options?(args)
      options_merge!(args.last, build_proc(extract_columns(args.last)))
      args.last.delete("only")
      args.last.delete("except")
    end
    before_save *args, &block
  end

  private

    def extract_columns(hash)
      if hash.has_key?(:only)
        [hash[:only]].flatten.map(&:to_s)
      elsif hash.has_key?(:except)
        columns.map { |column| column.name } - [hash[:except]].flatten.map(&:to_s)
      end
    end

    def build_proc(columns)
      Proc.new do |model|
        changed = model.changed
        columns.all? { |column| changed.include?(column) }
      end
    end

    def extractable_options?(args)
      args.last.is_a?(Hash) && args.last.extractable_options?
    end

    # Quoted from Array#extract_options! (Defined in ActiveSupport)
    def options_merge!(hash, proc)
      if hash.has_key?(:if)
        if hash[:if].is_a?(Array)
          hash[:if].push(proc)
        else
          hash[:if] = [hash[:if], proc]
        end
      else
        hash[:if] = proc
      end
    end
end

ActiveRecord::Base.extend ActiveSniper
