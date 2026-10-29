class Androidtether < Formula
  desc "Android USB tethering for Mac: userspace RNDIS, no kernel extension"
  homepage "https://github.com/aarif2/androidtether"
  url "https://github.com/aarif2/androidtether/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "164b1f765a108f569cbb8238747b178968f41a3a480a0876bffb20444fc8f9a2"
  license "MIT"

  depends_on :macos
  depends_on "libusb" => :build

  def install
    system "make", "LIBUSB_PREFIX=#{Formula["libusb"].opt_prefix}"
    sbin.install "androidtetherd"
  end

  service do
    run [opt_sbin/"androidtetherd"]
    keep_alive true
    log_path "/var/log/androidtether.log"
    error_log_path "/var/log/androidtether.log"
  end

  def caveats
    <<~EOS
      Start the service (needs root to create network interfaces):
        sudo brew services start androidtether
      Then plug in your phone and turn on USB tethering.
    EOS
  end

  test do
    assert_match "must run as root", shell_output("#{sbin}/androidtetherd 2>&1", 1)
  end
end
