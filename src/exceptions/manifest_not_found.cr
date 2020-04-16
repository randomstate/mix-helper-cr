module Mix::Helper
    class ManifestNotFound < Exception
        def initialize(@path : String)
            @message = "Mix Manifest was not found in: #{@path}"
        end
    end
end
