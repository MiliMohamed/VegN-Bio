import 'package:flutter/material.dart';

class MenuFilters extends StatefulWidget {
  final List<String> categories;
  final String selectedCategory;
  final List<String> excludedAllergens;
  final bool showVeganOnly;
  final bool showVegetarianOnly;
  final bool showGlutenFreeOnly;
  final Function(String) onCategoryChanged;
  final Function(String) onAllergenToggled;
  final VoidCallback onVeganToggled;
  final VoidCallback onVegetarianToggled;
  final VoidCallback onGlutenFreeToggled;
  final VoidCallback onClearFilters;

  const MenuFilters({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.excludedAllergens,
    required this.showVeganOnly,
    required this.showVegetarianOnly,
    required this.showGlutenFreeOnly,
    required this.onCategoryChanged,
    required this.onAllergenToggled,
    required this.onVeganToggled,
    required this.onVegetarianToggled,
    required this.onGlutenFreeToggled,
    required this.onClearFilters,
  });

  @override
  State<MenuFilters> createState() => _MenuFiltersState();
}

class _MenuFiltersState extends State<MenuFilters> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildFilterHeader(),
          if (_isExpanded) ...[
            const SizedBox(height: 16),
            _buildCategoryFilters(),
            const SizedBox(height: 16),
            _buildDietaryFilters(),
            const SizedBox(height: 16),
            _buildAllergenFilters(),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterHeader() {
    final hasActiveFilters = widget.selectedCategory != 'Tous' ||
        widget.excludedAllergens.isNotEmpty ||
        widget.showVeganOnly ||
        widget.showVegetarianOnly ||
        widget.showGlutenFreeOnly;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.tune,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          const Text(
            'Filtres',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          if (hasActiveFilters)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_getActiveFilterCount()} actif${_getActiveFilterCount() > 1 ? 's' : ''}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => setState(() => _isExpanded = !_isExpanded),
            icon: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Catégories',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.categories.map((category) {
              final isSelected = category == widget.selectedCategory;
              return FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    widget.onCategoryChanged(category);
                  }
                },
                selectedColor: Colors.green[100],
                checkmarkColor: Colors.green[700],
                backgroundColor: Colors.grey[100],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDietaryFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Régimes alimentaires',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDietaryFilter(
                  'Végan',
                  widget.showVeganOnly,
                  widget.onVeganToggled,
                  Colors.green,
                  Icons.eco,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDietaryFilter(
                  'Végétarien',
                  widget.showVegetarianOnly,
                  widget.onVegetarianToggled,
                  Colors.lightGreen,
                  Icons.eco,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildDietaryFilter(
            'Sans gluten',
            widget.showGlutenFreeOnly,
            widget.onGlutenFreeToggled,
            Colors.orange,
            Icons.no_food,
          ),
        ],
      ),
    );
  }

  Widget _buildDietaryFilter(
    String label,
    bool isSelected,
    VoidCallback onToggle,
    Color color,
    IconData icon,
  ) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? color : Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? color : Colors.grey[700],
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                size: 16,
                color: color,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllergenFilters() {
    final commonAllergens = [
      'gluten',
      'lactose',
      'œufs',
      'arachides',
      'noix',
      'soja',
      'poisson',
      'crustacés',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Allergènes à exclure',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (widget.excludedAllergens.isNotEmpty)
                TextButton(
                  onPressed: widget.onClearFilters,
                  child: const Text(
                    'Effacer',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: commonAllergens.map((allergen) {
              final isExcluded = widget.excludedAllergens.contains(allergen);
              return FilterChip(
                label: Text(allergen),
                selected: isExcluded,
                onSelected: (selected) {
                  widget.onAllergenToggled(allergen);
                },
                selectedColor: Colors.red[100],
                checkmarkColor: Colors.red[700],
                backgroundColor: Colors.grey[100],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (widget.selectedCategory != 'Tous') count++;
    if (widget.excludedAllergens.isNotEmpty) count++;
    if (widget.showVeganOnly) count++;
    if (widget.showVegetarianOnly) count++;
    if (widget.showGlutenFreeOnly) count++;
    return count;
  }
}
