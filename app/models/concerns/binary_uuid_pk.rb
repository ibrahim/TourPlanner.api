module BinaryUuidPk
  extend ActiveSupport::Concern

  included do
    before_validation :set_id, on: :create
    validates :id, presence: true
  end

  def set_id
    uuid_object = SimpleUUID::UUID.new
    uuid_string = ApplicationRecord.rearrange_time_of_uuid( uuid_object.to_guid )
    uuid_binary = ApplicationRecord.id_binary( uuid_string )
    self.id = uuid_binary
  end

  def uuid
    self[:uuid] || (id.present? ? ApplicationRecord.format_uuid_with_hyphens( id.unpack('H*').first ).upcase : nil)
  end

  module ClassMethods
    def format_uuid_with_hyphens( uuid_string_without_hyphens )
      uuid_string_without_hyphens.rjust(32, '0').gsub(/^(.{8})(.{4})(.{4})(.{4})(.{12})$/, '\1-\2-\3-\4-\5')
    end

    def rearrange_time_of_uuid( uuid_string )
      uuid_string_without_hyphens = "#{uuid_string[14, 4]}#{uuid_string[9, 4]}#{uuid_string[0, 8]}#{uuid_string[19, 4]}#{uuid_string[24..-1]}"
      ApplicationRecord.format_uuid_with_hyphens( uuid_string_without_hyphens )
    end

    def id_binary( uuid_string )
      # Alternate way: Array(uuid_string.downcase.gsub(/[^a-f0-9]/, '')).pack('H*')
      SimpleUUID::UUID.new( uuid_string ).to_s
    end

    def id_str( uuid_binary_string )
      SimpleUUID::UUID.new( uuid_binary_string ).to_guid
    end

    # Support both binary and text as IDs
    def find( *ids )
      ids = [ids] unless ids.is_a?( Array )
      ids = ids.flatten

      array_binary_ids = ids.each_with_object( [] ) do |id, array|
        case id
        when Integer
          raise TypeError, 'Expecting only 36 character UUID strings as primary keys'
        else
          array <<  SimpleUUID::UUID.new( id ).to_s

        end
      end

      super( array_binary_ids )
    end
  end
end
