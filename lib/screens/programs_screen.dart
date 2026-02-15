import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:daily_reset/models/program_pack.dart';
import 'package:daily_reset/components/core/components.dart';

class ProgramsScreen extends StatelessWidget {
  const ProgramsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final packs = ProgramPacksRepository.defaultPacks;

    return Scaffold(
      appBar: const DRAppBar(title: 'Programs'),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: packs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final pack = packs[index];

          return DRCard(
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.circular(16),
            child: DRListTile(
              onTap: () {
                context.push('/programs/${pack.id}');
              },
              leading: _ProgramIcon(iconKey: pack.iconKey),
              title: pack.name,
              subtitle: pack.description,
              trailing: _ActiveBadge(isActive: pack.isActive),
            ),
          );
        },
      ),
    );
  }
}

class _ProgramIcon extends StatelessWidget {
  final String iconKey;

  const _ProgramIcon({required this.iconKey});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    switch (iconKey) {
      case 'water':
        icon = Icons.local_drink_outlined;
        break;
      case 'walk':
        icon = Icons.directions_walk_outlined;
        break;
      case 'focus':
        icon = Icons.center_focus_strong_outlined;
        break;
      case 'workout':
        icon = Icons.fitness_center_outlined;
        break;
      default:
        icon = Icons.apps_outlined;
        break;
    }

    return CircleAvatar(
      child: Icon(icon),
    );
  }
}

class _ActiveBadge extends StatelessWidget {
  final bool isActive;

  const _ActiveBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? colorScheme.primary.withValues(alpha: 0.15)
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isActive ? colorScheme.primary : colorScheme.outline,
          ),
          const SizedBox(width: 6),
          Text(
            isActive ? 'Active' : 'Inactive',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isActive ? colorScheme.primary : colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }
}
