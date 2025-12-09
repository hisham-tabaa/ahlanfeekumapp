import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../../domain/entities/search_entities.dart';
import '../../data/models/search_filter.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/utils/web_compatible_network_image.dart';
import '../../../../core/utils/web_scroll_behavior.dart';
import '../../../../core/constants/app_constants.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSort = 'lowest_price';
  final ScrollController _scrollController = ScrollController();
  SearchFilter? _currentFilter;

  @override
  void initState() {
    super.initState();

    // Set up pagination scroll listener
    _scrollController.addListener(_onScroll);

    // Get filter from route arguments and trigger search directly
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      final filter = args != null && args['filter'] != null
          ? args['filter'] as SearchFilter
          : const SearchFilter(); // Use default filter if none provided

      _currentFilter = filter;

      // Check if lookups are loaded, if not load them first
      final currentState = context.read<SearchBloc>().state;
      if (currentState is! LookupsLoaded && currentState is! SearchLoaded) {
        // Load lookups first, then search
        context.read<SearchBloc>().add(const LoadLookupsEvent());
        // The search will be triggered after lookups are loaded
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            context.read<SearchBloc>().add(
              SearchPropertiesEvent(filter: filter),
            );
          }
        });
      } else {
        // Lookups already loaded, search directly
        context.read<SearchBloc>().add(SearchPropertiesEvent(filter: filter));
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'search_results'.tr(),
          style: AppTextStyles.h4.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: ResponsiveLayout(
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SearchError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: ResponsiveUtils.fontSize(context, mobile: 64, tablet: 72, desktop: 80),
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20)),
                    Text(
                      'something_went_wrong'.tr(),
                      style: AppTextStyles.h4.copyWith(color: Colors.grey[600]),
                    ),
                    SizedBox(height: ResponsiveUtils.spacing(context, mobile: 8, tablet: 10, desktop: 12)),
                    Text(
                      state.message.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20)),
                    ElevatedButton(
                      onPressed: () => context.read<SearchBloc>().add(
                        const LoadLookupsEvent(),
                      ),
                      child: Text('retry'.tr()),
                    ),
                  ],
                ),
              );
            }

            if (state is SearchLoaded) {
              return Column(
                children: [
                  _buildSearchHeader(state),
                  Expanded(
                    child: state.properties.isEmpty
                        ? _buildEmptyState()
                        : _buildPropertyGrid(state.properties),
                  ),
                ],
              );
            }

            if (state is LookupsLoaded) {
              return const Center(
                child: Text('Start searching to see results'),
              );
            }

            return const Center(child: Text('Loading...'));
          },
        ),
      ),
    );
  }

  Widget _buildSearchHeader(SearchLoaded state) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context, mobile: 20, tablet: 24, desktop: 28)),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context, mobile: 12, tablet: 14, desktop: 16)),
                    border: Border.all(
                      color: AppColors.border.withValues(alpha: 0.3),
                    ),
                  ),
                  child: TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Something',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.textSecondary,
                        size: ResponsiveUtils.fontSize(context, mobile: 20, tablet: 22, desktop: 24),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20),
                        vertical: ResponsiveUtils.spacing(context, mobile: 12, tablet: 14, desktop: 16),
                      ),
                    ),
                    onFieldSubmitted: (value) {
                      if (value.trim().isNotEmpty && _currentFilter != null) {
                        final newFilter = _currentFilter!.copyWith(
                          filterText: value.trim(),
                          address: value.trim(),
                        );
                        _currentFilter = newFilter;
                        context.read<SearchBloc>().add(
                          SearchPropertiesEvent(filter: newFilter),
                        );
                      }
                    },
                  ),
                ),
              ),
              SizedBox(width: ResponsiveUtils.spacing(context, mobile: 12, tablet: 14, desktop: 16)),
              GestureDetector(
                onTap: () async {

                  if (!mounted) {
                    return;
                  }

                  try {

                    await Navigator.of(context).pushNamed(
                      '/filter',
                      arguments: {'filter': state.currentFilter},
                    );

                  } catch (e) {

                    // Fallback navigation
                    if (mounted) {
                      try {
                        await Navigator.of(context).pushNamed(
                          '/filter',
                          arguments: {'filter': const SearchFilter()},
                        );
                      } catch (fallbackError) {
                      }
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(ResponsiveUtils.spacing(context, mobile: 12, tablet: 14, desktop: 16)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context, mobile: 12, tablet: 14, desktop: 16)),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Icon(
                    Icons.tune,
                    color: AppColors.textSecondary,
                    size: ResponsiveUtils.fontSize(context, mobile: 20, tablet: 22, desktop: 24),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.spacing(context, mobile: 20, tablet: 24, desktop: 28)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'results_found'.tr(args: ['${state.totalCount}']),
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () => _showSortBottomSheet(),
                child: Text(
                  'sort_by'.tr(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyGrid(List<PropertyEntity> properties) {
    // Sort properties based on selected sort option
    List<PropertyEntity> sortedProperties = List.from(properties);
    if (_selectedSort == 'lowest_price') {
      sortedProperties.sort(
        (a, b) => a.pricePerNight.compareTo(b.pricePerNight),
      );
    } else if (_selectedSort == 'highest_price') {
      sortedProperties.sort(
        (a, b) => b.pricePerNight.compareTo(a.pricePerNight),
      );
    }

    return WebScrollUtils.gridView(
      controller: _scrollController,
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20)),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: ResponsiveUtils.size(context, mobile: 160, tablet: 180, desktop: 200),
        crossAxisSpacing: ResponsiveUtils.spacing(context, mobile: 12, tablet: 14, desktop: 16),
        mainAxisSpacing: ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20),
        childAspectRatio: ResponsiveUtils.size(context, mobile: 160, tablet: 180, desktop: 200) / ResponsiveUtils.size(context, mobile: 260, tablet: 280, desktop: 300),
      ),
      itemCount: sortedProperties.length,
      itemBuilder: (context, index) {
        final property = sortedProperties[index];
        return _buildPropertyCard(context, property);
      },
    );
  }

  Widget _buildPropertyCard(BuildContext context, PropertyEntity property) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/property-detail',
          arguments: property.id,
        );
      },
      child: SizedBox(
        width: ResponsiveUtils.size(context, mobile: 160, tablet: 180, desktop: 200),
        height: ResponsiveUtils.size(context, mobile: 260, tablet: 280, desktop: 300),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context, mobile: 16, tablet: 18, desktop: 20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fixed height image container
              SizedBox(
                width: ResponsiveUtils.size(context, mobile: 160, tablet: 180, desktop: 200),
                height: ResponsiveUtils.size(context, mobile: 150, tablet: 170, desktop: 190),
                child: Stack(
                  children: [
                    Container(
                      width: ResponsiveUtils.size(context, mobile: 160, tablet: 180, desktop: 200),
                      height: ResponsiveUtils.size(context, mobile: 150, tablet: 170, desktop: 190),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context, mobile: 16, tablet: 18, desktop: 20)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context, mobile: 16, tablet: 18, desktop: 20)),
                        child: property.mainImage != null
                            ? WebCompatibleNetworkImage(
                                imageUrl: _buildFullImageUrl(property.mainImage!),
                                width: ResponsiveUtils.size(context, mobile: 160, tablet: 180, desktop: 200),
                                height: ResponsiveUtils.size(context, mobile: 150, tablet: 170, desktop: 190),
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) {
                                  return Image.asset(
                                    'assets/images/bulding.jpg',
                                    width: ResponsiveUtils.size(context, mobile: 160, tablet: 180, desktop: 200),
                                    height: ResponsiveUtils.size(context, mobile: 150, tablet: 170, desktop: 190),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: ResponsiveUtils.size(context, mobile: 160, tablet: 180, desktop: 200),
                                        height: ResponsiveUtils.size(context, mobile: 120, tablet: 135, desktop: 150),
                                        color: Colors.grey[300],
                                        child: Icon(
                                          Icons.image_not_supported,
                                          color: Colors.grey[500],
                                        ),
                                      );
                                    },
                                  );
                                },
                              )
                            : Image.asset(
                                'assets/images/bulding.jpg',
                                width: ResponsiveUtils.size(context, mobile: 160, tablet: 180, desktop: 200),
                                height: ResponsiveUtils.size(context, mobile: 120, tablet: 135, desktop: 150),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: ResponsiveUtils.size(context, mobile: 160, tablet: 180, desktop: 200),
                                    height: ResponsiveUtils.size(context, mobile: 120, tablet: 135, desktop: 150),
                                    color: Colors.grey[300],
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey[500],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                    Positioned(
                      top: ResponsiveUtils.spacing(context, mobile: 12, tablet: 14, desktop: 16),
                      right: ResponsiveUtils.spacing(context, mobile: 12, tablet: 14, desktop: 16),
                      child: Container(
                        padding: EdgeInsets.all(ResponsiveUtils.spacing(context, mobile: 6, tablet: 7, desktop: 8)),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context, mobile: 20, tablet: 22, desktop: 24)),
                        ),
                        child: Icon(
                          Icons.favorite_border,
                          color: AppColors.primary,
                          size: ResponsiveUtils.fontSize(context, mobile: 16, tablet: 18, desktop: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(ResponsiveUtils.spacing(context, mobile: 8, tablet: 10, desktop: 12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Rating badge between image and title
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.spacing(context, mobile: 6, tablet: 7, desktop: 8),
                          vertical: ResponsiveUtils.spacing(context, mobile: 3, tablet: 4, desktop: 5),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warning,
                          borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context, mobile: 10, tablet: 12, desktop: 14)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.white, size: ResponsiveUtils.fontSize(context, mobile: 10, tablet: 11, desktop: 12)),
                            SizedBox(width: ResponsiveUtils.spacing(context, mobile: 2, tablet: 3, desktop: 4)),
                            Text(
                              property.rating != null
                                  ? property.rating!.toStringAsFixed(1)
                                  : '0.0',
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: ResponsiveUtils.fontSize(context, mobile: 10, tablet: 11, desktop: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Title
                      Flexible(
                        child: Text(
                          property.title,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: ResponsiveUtils.fontSize(context, mobile: 12, tablet: 13, desktop: 14),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Price
                      Row(
                        children: [
                          Text(
                            '\$${property.pricePerNight.toStringAsFixed(0)}',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: ResponsiveUtils.fontSize(context, mobile: 14, tablet: 15, desktop: 16),
                            ),
                          ),
                          Text(
                            ' /Night',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: ResponsiveUtils.fontSize(context, mobile: 10, tablet: 11, desktop: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: ResponsiveUtils.fontSize(context, mobile: 64, tablet: 72, desktop: 80), color: Colors.grey[400]),
          SizedBox(height: ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20)),
          Text(
            'no_results_found'.tr(),
            style: AppTextStyles.h4.copyWith(color: Colors.grey[600]),
          ),
          SizedBox(height: ResponsiveUtils.spacing(context, mobile: 8, tablet: 10, desktop: 12)),
          Text(
            'try_adjusting_filters'.tr(),
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveUtils.radius(context, mobile: 20, tablet: 22, desktop: 24))),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(ResponsiveUtils.spacing(context, mobile: 24, tablet: 28, desktop: 32)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: ResponsiveUtils.size(context, mobile: 40, tablet: 45, desktop: 50),
              height: ResponsiveUtils.size(context, mobile: 4, tablet: 5, desktop: 6),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context, mobile: 2, tablet: 3, desktop: 4)),
              ),
            ),
            SizedBox(height: ResponsiveUtils.spacing(context, mobile: 20, tablet: 24, desktop: 28)),
            Text(
              'sort_by'.tr(),
              style: AppTextStyles.h4.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: ResponsiveUtils.spacing(context, mobile: 24, tablet: 28, desktop: 32)),
            _buildSortOption('lowest_price'),
            _buildSortOption('highest_price'),
            SizedBox(height: ResponsiveUtils.spacing(context, mobile: 20, tablet: 24, desktop: 28)),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String option) {
    final isSelected = _selectedSort == option;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSort = option;
        });
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20)),
        child: Row(
          children: [
            Container(
              width: ResponsiveUtils.size(context, mobile: 20, tablet: 22, desktop: 24),
              height: ResponsiveUtils.size(context, mobile: 20, tablet: 22, desktop: 24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.green : AppColors.border,
                  width: 2,
                ),
                color: isSelected ? AppColors.green : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(Icons.check, color: Colors.white, size: ResponsiveUtils.fontSize(context, mobile: 12, tablet: 13, desktop: 14))
                  : null,
            ),
            SizedBox(width: ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20)),
            Expanded(
              child: Text(
                option.tr(),
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // User reached the end of the list, load more
      _loadMoreResults();
    }
  }

  void _loadMoreResults() async {
    if (!mounted) return;

    try {
      final bloc = context.read<SearchBloc>();
      if (bloc.isClosed) return;

      final state = bloc.state;

      if (state is SearchLoaded &&
          !state.hasReachedMax &&
          _currentFilter != null) {

        // Create a new filter with updated skip count for pagination
        final nextPageFilter = _currentFilter!.copyWith(
          skipCount: state.properties.length,
        );

        // Add event to load more results
        bloc.add(LoadMorePropertiesEvent(filter: nextPageFilter));
      }
    } catch (e) {
      // Pagination will stop gracefully
    }
  }

  String _buildFullImageUrl(String relativePath) {
    // If the path is already a complete URL, return it as is
    if (relativePath.startsWith('http://') || relativePath.startsWith('https://')) {
      return relativePath;
    }

    // Use the domain from AppConstants.baseUrl
    final uri = Uri.parse(AppConstants.baseUrl);
    final baseUrl = '${uri.scheme}://${uri.host}';

    if (relativePath.startsWith('/')) {
      return '$baseUrl$relativePath';
    }
    return '$baseUrl/$relativePath';
  }
}
