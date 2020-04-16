require "json"
require "./exceptions/*"

module Mix::Helper
  extend self

  def mix(path, manifest_dir = "")
    path = "/#{path.lchop("/")}"
    manifest_path = Path[Dir.current].join(manifest_dir, "/mix-manifest.json")
    hot_path = Path[Dir.current].join(manifest_dir, "/hot")

    if File.exists? hot_path
      url = File.read(hot_path)
        .strip
        .lchop("https://")
        .lchop("http://")

      if url.empty?
        url = "localhost:8080"
      end

      "//#{url}#{path}"
    else
      read_from_manifest(path, manifest_path)
    end
  end

  def clear_cache 
    MixCache.clear
  end

  private def read_from_manifest(path, manifest_path)
    if MixCache.manifests[manifest_path]?
      manifest_json = MixCache.manifests[manifest_path]
    else 
      begin 
        manifest = File.read(manifest_path)
        manifest_json = JSON.parse(manifest)
      rescue File::NotFoundError
        raise ManifestNotFound.new manifest_path.to_s
      end
    end
    
    MixCache.manifests[manifest_path] = manifest_json

    manifest_json[path]
  end

  private class MixCache 
    class_property manifests = {} of Path => JSON::Any

    def self.clear
      @@manifests = {} of Path => JSON::Any
    end
  end
end
