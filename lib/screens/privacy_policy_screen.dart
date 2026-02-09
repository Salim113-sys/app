import 'package:flutter/material.dart';
import 'package:daily_reset/theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: context.textStyles.headlineSmall?.semiBold,
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: AppSpacing.paddingMd,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.edit_note,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Placeholder Privacy Policy\nReplace this content with your actual privacy policy before publishing.',
                      style: context.textStyles.bodySmall?.medium.withColor(
                        Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Privacy Policy',
              style: context.textStyles.headlineMedium?.bold,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Last updated: ${DateTime.now().year}',
              style: context.textStyles.bodyMedium?.withColor(
                Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildSection(
              context,
              title: '1. Introduction',
              content:
                  'Daily Reset ("we", "our", or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application.',
            ),
            _buildSection(
              context,
              title: '2. Information We Collect',
              content:
                  'The app stores all data locally on your device. We collect and store:\n\n• Habit information (name, description, category, target days)\n• Daily mood logs\n• Habit completion records\n• App preferences (theme settings)\n\nAll data is stored locally on your device and is not transmitted to our servers.',
            ),
            _buildSection(
              context,
              title: '3. How We Use Your Information',
              content:
                  'We use the information you provide to:\n\n• Track your habits and progress\n• Display statistics and trends\n• Personalize your app experience\n• Maintain app functionality',
            ),
            _buildSection(
              context,
              title: '4. Data Storage and Security',
              content:
                  'Your data is stored locally on your device using secure storage mechanisms. We do not have access to your personal data. You are responsible for maintaining the security of your device.',
            ),
            _buildSection(
              context,
              title: '5. Third-Party Services',
              content:
                  'The app may contain advertisements provided by third-party ad networks (such as Google AdMob). These services may collect information about your device and usage patterns. Please refer to their privacy policies for more information.',
            ),
            _buildSection(
              context,
              title: '6. Children\'s Privacy',
              content:
                  'Our app is not intended for children under 13 years of age. We do not knowingly collect personal information from children under 13.',
            ),
            _buildSection(
              context,
              title: '7. Your Rights',
              content:
                  'You have the right to:\n\n• Access your data (viewable in the app)\n• Delete your data (use "Reset All Data" in Settings)\n• Control your data (all data is on your device)',
            ),
            _buildSection(
              context,
              title: '8. Changes to This Privacy Policy',
              content:
                  'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy in the app.',
            ),
            _buildSection(
              context,
              title: '9. Contact Us',
              content:
                  'If you have any questions about this Privacy Policy, please contact us at:\n\n[Your Contact Email]\n[Your Company Name]\n[Your Address]',
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textStyles.titleLarge?.semiBold,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            content,
            style: context.textStyles.bodyMedium?.withColor(
              Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
