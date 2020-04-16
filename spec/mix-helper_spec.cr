require "./spec_helper"

describe Mix::Helper do
  before_each do
    Mix::Helper.clear_cache
  end

  it "does not include host" do
    manifest = make_manifest
    result = mix "/unversioned.css"

    result.should eq "/versioned.css"
    manifest.delete
  end

  it "adds leading slash to asset if not included" do
    manifest = make_manifest
    result = mix "unversioned.css"

    result.should eq "/versioned.css"
    manifest.delete
  end

  it "throws error if mix manifest does not exist" do
    expect_raises ManifestNotFound do
      result = mix "/unversioned.css"
    end
  end

  it "can look for manifest in different directory" do
    manifest = make_manifest "spec/"
    result = mix "/unversioned.css", "/spec/"

    result.should eq "/versioned.css"
    manifest.delete
  end

  it "can find manifest if no leading slash provided" do
    manifest = make_manifest "spec/"
    result = mix "/unversioned.css", "spec/"

    result.should eq "/versioned.css"
    manifest.delete
  end

  it "can get hot url that contains https" do
    hot = make_hot_reload_file "https://app.test"
    result = mix "unversioned.css"

    result.should eq "//app.test/unversioned.css"

    hot.delete
  end

  it "can get hot url that contains http" do
    hot = make_hot_reload_file "http://app.test"
    result = mix "unversioned.css"

    result.should eq "//app.test/unversioned.css"

    hot.delete
  end

  it "can get hot url with https and custom manifest directory" do
    manifest = make_manifest "spec/"
    hot = make_hot_reload_file "https://app.test", "spec/"
    result = mix "unversioned.css", "spec/"

    result.should eq "//app.test/unversioned.css"

    manifest.delete
    hot.delete
  end

  it "can get hot url with http and custom manifest directory" do
    manifest = make_manifest "spec/"
    hot = make_hot_reload_file "http://app.test", "spec/"
    result = mix "unversioned.css", "spec/"

    result.should eq "//app.test/unversioned.css"
    
    manifest.delete
    hot.delete
  end

  it "uses localhost:8080 if hot file is empty" do
    manifest = make_manifest
    hot = make_hot_reload_file ""
    result = mix "unversioned.css"

    result.should eq "//localhost:8080/unversioned.css"

    manifest.delete
    hot.delete
  end

  it "uses localhost:8080 if hot file is empty in custom manifest directory" do
    manifest = make_manifest "spec/"
    hot = make_hot_reload_file "", "spec/"
    result = mix "unversioned.css", "spec/"

    result.should eq "//localhost:8080/unversioned.css"

    manifest.delete
    hot.delete
  end

  it "caches manifest files to prevent repeated file access" do
    manifest = make_manifest
    mix "unversioned.css"
    
    # Delete the file, meaning it can only get the right result if it has cached it
    manifest.delete

    result = mix "unversioned.css"
    result.should eq "/versioned.css"
  end
end

def make_manifest(dir = "")
  dir = Path[Dir.current].join(dir)
  file_path = "#{dir}/mix-manifest.json"

  File.write file_path, "{
    \"/unversioned.css\" : \"/versioned.css\"
  }"
  
  File.open file_path
end

def make_hot_reload_file(url, dir = "")
  dir = Path[Dir.current].join(dir)
  file_path = "#{dir}/hot"
  
  File.write file_path, "#{url}\n\r"

  File.open file_path
end
