require "activesniper/version"
require "active_record"

module ActiveSniper
  NON_STATE_CALLBACKS = [
      :before_validation, :after_validation,
      :after_rollback,
      :before_save, :after_save, :around_save,
      :before_update, :after_update, :around_update
  ]
  # TODO: Support :after_commit
  SAVE_BEFORE_STATE_CALLBACKS = [:after_commit]
  EXCEPT_COLUMNS = [:id, :created_at, :updated_at]

  NON_STATE_CALLBACKS.each do |base_callback|
    callback = (base_callback.to_s + '_snipe').to_sym
    define_method callback do |*args, &block|
      if extractable_options?(args)
        options_merge!(args.last, build_proc(extract_columns(args.last)))
        args.last.delete("only")
        args.last.delete("except")
      end
      send(base_callback, *args, &block)
    end
  end

  private

    def extract_columns(hash)
      if hash.has_key?(:only)
        [hash[:only]].flatten.map(&:to_s)
      elsif hash.has_key?(:except)
        columns.map { |column| column.name } - [hash[:except] + EXCEPT_COLUMNS].flatten.map(&:to_s)
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
