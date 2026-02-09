  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    // For LinkedIn, ensure it's a legitimate LinkedIn URL
    if (url.contains('linkedin.com') || url.contains('www.linkedin.com')) {
      if (uri.host != 'linkedin.com' && uri.host != 'www.linkedin.com') {
        // Invalid LinkedIn URL
        return;
      }
    }
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }