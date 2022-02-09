module Obfuscate
    def self.email ( h )
        if h.is_a? Hash
            if h['email'] && !h['email'].empty?
                email = h.delete('email')
                name, host = email.split("@")
                h['email'] = [Digest::SHA1.hexdigest(name), host].compact.join("@")
            end

            h.each_value do |v|
                self.email(v) if v.is_a? Hash
                v.each {|e| self.email(e)} if v.is_a? Array
            end
        end
    end
end