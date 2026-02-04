                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number (E.164)',
                      prefixIcon: Icon(Icons.phone),
                      hintText: '+1234567890',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return null;
                      final cleaned = value.replaceAll(RegExp(r'[	
 -()\[\]]'), '');
                      final regex = RegExp(r'^\+?[1-9]\d{6,14}$');
                      if (!regex.hasMatch(cleaned)) {
                        return 'Invalid phone format';
                      }
                      return null;
                    },
                  ),