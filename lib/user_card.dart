                    if (phoneNumber != null && phoneNumber!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        phoneNumber!,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _CallButton(
                            icon: Icons.phone,
                            color: const Color(0xFF007AFF),
                            onTap: () => _launchUrl('tel:$phoneNumber'),
                          ),
                          const SizedBox(width: 8),
                          _CallButton(
                            icon: Icons.chat,
                            color: const Color(0xFF25D366),
                            onTap: () => _launchUrl('https://wa.me/${phoneNumber!.replaceAll(RegExp(r'[^0-9]'), '')}'),
                          ),
                          if (linkedinUrl != null && linkedinUrl!.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            _CallButton(
                              icon: FontAwesomeIcons.linkedin,
                              color: const Color(0xFF0A66C2),
                              onTap: () => _launchUrl(linkedinUrl!),
                            ),
                          ],
                        ],
                      ),
                    ],