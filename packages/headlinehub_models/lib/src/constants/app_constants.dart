/// HeadlineHub application constants used across mobile, API, and dashboard.
/// This file contains all shared constant values and configurations.

/// Constants related to API configuration and endpoints.
/// Used for making HTTP requests to the HeadlineHub backend.
class ApiConstants {
  /// Base URL for the HeadlineHub API
  static const String baseUrl = 'api.headlinehub.com';

  /// API request timeout in seconds
  static const int timeout = 30; // seconds

  /// Current API version identifier
  static const String apiVersion = 'v1';

  /// Headlines endpoint for fetching and managing headlines
  static const String headlines = '/headlines';

  /// Categories endpoint for managing news categories
  static const String categories = '/categories';

  /// Users endpoint for user management operations
  static const String users = '/users';

  /// Authentication endpoint for login/signup operations
  static const String auth = '/auth';

  /// Sources endpoint for managing news sources
  static const String sources = '/sources';

  /// Search endpoint for headline search operations
  static const String search = '/search';

  /// Trending endpoint for fetching popular headlines
  static const String trending = '/trending';
}


/// Keys used for local storage operations.
/// Used consistently across all client applications.
class StorageKeys {
  /// Authentication related keys
  static const String authToken = 'auth_token';
  static const String refreshToken = 'refresh_token';
  static const String authExpiry = 'auth_expiry';
  static const String deviceId = 'device_id';
  
  /// User profile related keys
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userName = 'user_name';
  static const String userRole = 'user_role';
  static const String userAvatar = 'user_avatar';
  
  /// User preferences
  static const Map<String, String> preferences = {
    'theme': 'user_theme_preference',
    'language': 'user_language_preference',
    'notifications': 'user_notifications_preference',
    'fontSize': 'user_font_size_preference',
    'autoRefresh': 'user_auto_refresh_preference',
  };
  
  /// Content related keys
  static const Map<String, String> content = {
    'categories': 'selected_categories',
    'sources': 'followed_sources',
    'bookmarks': 'bookmarked_headlines',
    'readLater': 'read_later_headlines',
    'history': 'reading_history',
  };
  
  /// Search related keys
  static const Map<String, String> search = {
    'history': 'search_history',
    'filters': 'search_filters',
    'suggestions': 'search_suggestions',
    'recentQueries': 'recent_search_queries',
  };
  
  /// Sync related keys
  static const Map<String, String> sync = {
    'lastSync': 'last_sync_timestamp',
    'syncStatus': 'sync_status',
    'pendingChanges': 'pending_sync_changes',
    'conflictResolution': 'sync_conflict_resolution',
  };
  
  /// Cache related keys
  static const Map<String, String> cache = {
    'version': 'cache_version',
    'size': 'cache_size',
    'lastCleanup': 'cache_last_cleanup',
    'strategy': 'cache_strategy',
  };

  /// Session related keys
  static const Map<String, String> session = {
    'isActive': 'session_is_active',
    'startTime': 'session_start_time',
    'lastActivity': 'session_last_activity',
    'deviceInfo': 'session_device_info',
  };
  
  /// Analytics related keys
  static const Map<String, String> analytics = {
    'userId': 'analytics_user_id',
    'sessionId': 'analytics_session_id',
    'optIn': 'analytics_opt_in',
    'customEvents': 'analytics_custom_events',
  };
  
  /// Feature flags
  static const Map<String, String> features = {
    'newUI': 'feature_new_ui_enabled',
    'beta': 'feature_beta_enabled',
    'premium': 'feature_premium_enabled',
    'experimental': 'feature_experimental_enabled',
  };
  
  /// Utility methods
  static String getPreferenceKey(String preference) => preferences[preference] ?? '';
  static String getContentKey(String contentType) => content[contentType] ?? '';
  static String getSearchKey(String searchType) => search[searchType] ?? '';
  static String getSyncKey(String syncType) => sync[syncType] ?? '';
  static String getCacheKey(String cacheType) => cache[cacheType] ?? '';
  static String getSessionKey(String sessionType) => session[sessionType] ?? '';
  static String getAnalyticsKey(String analyticsType) => analytics[analyticsType] ?? '';
  static String getFeatureKey(String feature) => features[feature] ?? '';
}


/// Analytics event identifiers for tracking user actions.
/// Used for consistent event tracking across platforms.
class AnalyticsEvents {
  /// Mobile App Events
  static const String appLaunched = 'app_launched';
  static const String appCrashed = 'app_crashed';
  static const String appVersionUpdated = 'app_version_updated';
  
  /// User Session Events
  static const String userLogin = 'user_logged_in';
  static const String userLogout = 'user_logged_out';
  static const String userSignup = 'user_signed_up';
  static const String sessionTimeout = 'session_timed_out';
  static const String tokenRefreshed = 'token_refreshed';
  
  /// Content Interaction Events
  static const String headlineViewed = 'headline_viewed';
  static const String headlineShared = 'headline_shared';
  static const String headlineBookmarked = 'headline_bookmarked';
  static const String categorySelected = 'category_selected';
  static const String sourceFollowed = 'source_followed';
  static const String sourceUnfollowed = 'source_unfollowed';
  
  /// Search Events
  static const String searchPerformed = 'search_performed';
  static const String searchFiltered = 'search_filtered';
  static const String searchResultClicked = 'search_result_clicked';
  static const String searchFailed = 'search_failed';
  static const String suggestionsViewed = 'suggestions_viewed';
  
  /// Performance Events
  static const String apiLatency = 'api_latency_recorded';
  static const String cacheHit = 'cache_hit';
  static const String cacheMiss = 'cache_miss';
  static const String errorOccurred = 'error_occurred';
  
  /// Dashboard Events
  static const String dashboardAccessed = 'dashboard_accessed';
  static const String reportGenerated = 'report_generated';
  static const String settingsUpdated = 'settings_updated';
  static const String userManaged = 'user_managed';
  static const String sourceVerified = 'source_verified';
  
  /// API Health Events
  static const String apiRequestMade = 'api_request_made';
  static const String rateLimitExceeded = 'rate_limit_exceeded';
  static const String serviceHealthCheck = 'service_health_check';
  static const String databaseOperation = 'database_operation';
}

/// User role definitions and permissions.
/// Used for access control across the application.
class RoleConstants {
  /// Role identifiers
  static const String admin = 'admin';
  static const String editor = 'editor';
  static const String moderator = 'moderator';
  static const String viewer = 'viewer';
  static const String guest = 'guest';

  /// Role hierarchy (higher number = more permissions)
  static const Map<String, int> roleHierarchy = {
    'admin': 100,
    'editor': 75,
    'moderator': 50,
    'viewer': 25,
    'guest': 0,
  };

  /// Permission definitions grouped by feature area
  static const Map<String, List<String>> rolePermissions = {
    'admin': [
      // System Management
      'system.manage_settings',
      'system.view_logs',
      'system.manage_roles',
      
      // User Management
      'users.create',
      'users.update',
      'users.delete',
      'users.view_all',
      
      // Content Management
      'headlines.create',
      'headlines.update',
      'headlines.delete',
      'headlines.publish',
      'headlines.unpublish',
      
      // Source Management
      'sources.create',
      'sources.update',
      'sources.delete',
      'sources.block',
      
      // Category Management
      'categories.create',
      'categories.update',
      'categories.delete',
      
      // Analytics
      'analytics.view_all',
      'analytics.export',
      
      // All lower role permissions
      // ...editor.rolePermissions,
    ],
    
    'editor': [
      // Content Management
      'headlines.review',
      'headlines.edit',
      'headlines.schedule',
      
      // Source Management
      'sources.manage',
      'sources.verify',
      
      // Category Management
      'categories.assign',
      'categories.reorder',
      
      // Analytics
      'analytics.view_content',
      
      // All lower role permissions
      // ...moderator.rolePermissions,
    ],
    
    'moderator': [
      // Content Moderation
      'headlines.review',
      'headlines.flag',
      'headlines.feature',
      
      // User Content
      'comments.moderate',
      'reports.handle',
      
      // Analytics
      'analytics.view_basic',
      
      // All lower role permissions
      // ...viewer.rolePermissions,
    ],
    
    'viewer': [
      // Basic Permissions
      'headlines.read',
      'headlines.bookmark',
      'headlines.share',
      
      // User Features
      'profile.manage',
      'preferences.update',
      
      // Social Features
      'comments.create',
      'comments.edit_own',
      'comments.delete_own',
      
      // Source Interaction
      'sources.follow',
      'sources.unfollow',
      
      // All lower role permissions
      // ...guest.rolePermissions,
    ],
    
    'guest': [
      // Public Access
      'headlines.view',
      'categories.view',
      'sources.view',
      'search.basic',
    ],
  };

  /// Access control flags
  static const Map<String, Map<String, bool>> accessFlags = {
    'admin': {'canManageSystem': true, 'canOverride': true},
    'editor': {'canPublish': true, 'canEdit': true},
    'moderator': {'canReview': true, 'canFlag': true},
    'viewer': {'canRead': true, 'canShare': true},
    'guest': {'canRead': true, 'canShare': false},
  };

  /// Role limits
  static const Map<String, Map<String, int>> roleLimits = {
    'admin': {'maxSources': -1, 'maxCategories': -1}, // -1 = unlimited
    'editor': {'maxSources': 100, 'maxCategories': 50},
    'moderator': {'maxSources': 50, 'maxCategories': 25},
    'viewer': {'maxSources': 20, 'maxCategories': 10},
    'guest': {'maxSources': 5, 'maxCategories': 3},
  };

  /// Role status indicators
  static const Map<String, String> roleStatus = {
    'admin': 'System Administrator',
    'editor': 'Content Editor',
    'moderator': 'Content Moderator',
    'viewer': 'Regular User',
    'guest': 'Guest User',
  };
}

/// Input validation rules and constraints.
/// Ensures data integrity across all platforms.
class ValidationConstants {
  /// Length constraints
  static const int passwordMinLength = 8;
  static const int passwordMaxLength = 32;
  static const int titleMinLength = 5;
  static const int titleMaxLength = 100;
  static const int summaryMaxLength = 200;
  static const int sourceUrlMaxLength = 500;
  static const int maxTitleWords = 20;
  static const int maxSummaryWords = 50;
  static const int usernameMixLength = 3;
  static const int usernameMaxLength = 30;
  
  /// Regular expressions
  static const String urlPattern = r'^https?:\/\/[\w\-]+(\.[\w\-]+)+[/#?]?.*$';
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String usernamePattern = r'^[a-zA-Z0-9_-]{3,30}$';
  static const String namePattern = r'^[a-zA-Z\s-]{2,50}$';
  static const String phonePattern = r'^\+?[1-9]\d{1,14}$';
  
  /// Password requirements
  static const String passwordPattern = r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,32}$';
  static const Map<String, String> passwordRules = {
    'uppercase': r'[A-Z]',
    'lowercase': r'[a-z]',
    'number': r'[0-9]',
    'special': r'[@$!%*?&]',
  };
  
    

  
}

/// API rate limiting configurations.
/// Prevents abuse and ensures fair usage.
class RateLimitConstants {
  /// Default rate limits per user tier
  static const Map<String, Map<String, int>> tierLimits = {
    'free': {
      'requestsPerMinute': 30,
      'searchesPerMinute': 5,
      'sourcesPerHour': 5,
      'dailyRequests': 1000,
    },
    'premium': {
      'requestsPerMinute': 60,
      'searchesPerMinute': 10,
      'sourcesPerHour': 10,
      'dailyRequests': 5000,
    },
  };

  /// Endpoint-specific rate limits
  static const Map<String, int> endpointLimits = {
    'auth': 5,        // per minute
    'search': 10,     // per minute
    'headlines': 30,  // per minute
    'sources': 20,    // per minute
    'trending': 15,   // per minute
  };

  /// Penalty durations
  static const Duration softBanDuration = Duration(minutes: 15);
  static const Duration hardBanDuration = Duration(hours: 24);
  static const int maxViolationsBeforeHardBan = 5;

  /// Throttling settings
  /// Used to prevent abuse and ensure fair usage of the API
  static const Duration burstDelay = Duration(milliseconds: 100); 
  /// Maximum number of requests allowed in a burst period
  static const int burstSize = 5;
  /// Cooldown period after burst limit is reached
  static const Duration cooldownPeriod = Duration(minutes: 5);

  /// Rate limit headers used to communicate rate limits to clients and enforce restrictions
  /// Total requests allowed per minute 
  static const String limitHeader = 'X-RateLimit-Limit'; 
  /// Remaining requests before rate limit is reached
  static const String remainingHeader = 'X-RateLimit-Remaining';
  /// Time until rate limit resets (in seconds)
  static const String resetHeader = 'X-RateLimit-Reset';
  
  /// IP-based rate limiting
  static const int maxIpRequestsPerMinute = 300;
  static const Duration ipBanDuration = Duration(hours: 1);
  
  /// Recovery and grace periods
  /// Time after which rate limit counters are reset
  static const Duration gracePeriod = Duration(minutes: 1);
  static const double burstAllowance = 1.5; // Allow 50% more requests during burst period
  static const int retryAfterMultiplier = 2; // Multiplier for retry-after header in seconds
}

/// Asset and media handling configurations.
/// Centralizes asset management and media processing across platforms.
class AssetConstants {
  /// Base paths
  static const String imagePath = 'assets/images';
  static const String iconPath = 'assets/icons';
  static const String animationPath = 'assets/animations';
  static const String vectorPath = 'assets/vectors';
  
  /// Media processing configurations
  static const int maxImageSize = 1 * 1024 * 1024; // 1MB
  static const List<String> supportedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  static const double imageQuality = 0.8;
  
  /// Image dimensions
  static const Map<String, Map<String, int>> imageSizes = {
    'thumbnail': {'width': 300, 'height': 200},
    'preview': {'width': 600, 'height': 400},
    'full': {'width': 1200, 'height': 800},
    'avatar': {'width': 100, 'height': 100},
    'icon': {'width': 48, 'height': 48},
  };
  
  /// Cache settings
  static const int imageCacheMaxAge = 7 * 24 * 60 * 60; // 7 days
  static const int maxCachedImages = 100;
  static const String cachePath = 'cache/images';
  
  /// Branding assets
  static const String appLogo = '$imagePath/logo.png';
  static const String appLogoLight = '$imagePath/logo_light.png';
  static const String appLogoDark = '$imagePath/logo_dark.png';
  static const String appIcon = '$iconPath/app_icon.png';
  static const String splashAnimation = '$animationPath/splash.json';
  
  /// User assets
  static const String defaultUserAvatar = '$imagePath/default_avatar.png';
  static const String userAvatarPlaceholder = '$imagePath/avatar_placeholder.png';
  static const String userProfileBackground = '$imagePath/profile_bg.png';
  
  /// Content placeholder assets
  static const String placeholderImage = '$imagePath/default_headline.png';
  static const String errorImage = '$imagePath/error.png';
  static const String noResultsImage = '$imagePath/no_results.png';
  static const String offlineImage = '$imagePath/offline.png';
  
  /// Category icons with metadata
  static const Map<String, Map<String, dynamic>> categoryAssets = {
    'business': {
      'icon': '$iconPath/business.png',
      'color': '#1565C0',
      'vector': '$vectorPath/business.svg',
    },
    'technology': {
      'icon': '$iconPath/technology.png',
      'color': '#00796B',
      'vector': '$vectorPath/technology.svg',
    },
    // ...add other categories with their assets
  };
  
  /// UI elements
  static const String loadingSpinner = '$animationPath/loading.json';
  static const String pullToRefresh = '$animationPath/pull_to_refresh.json';
  static const String emptyState = '$animationPath/empty_state.json';
  
  /// Social sharing assets
  static const Map<String, Map<String, String>> socialAssets = {
    'facebook': {
      'icon': '$iconPath/facebook.png',
      'banner': '$imagePath/facebook_banner.png',
    },
    'twitter': {
      'icon': '$iconPath/twitter.png',
      'banner': '$imagePath/twitter_banner.png',
    },
    'linkedin': {
      'icon': '$iconPath/linkedin.png',
      'banner': '$imagePath/linkedin_banner.png',
    },
  };
  
  /// Media processing options
  static const Map<String, double> qualityPresets = {
    'low': 0.6,
    'medium': 0.8,
    'high': 0.9,
    'lossless': 1.0,
  };
  
  /// Asset preloading configurations
  static const List<String> preloadAssets = [
    appLogo,
    defaultUserAvatar,
    placeholderImage,
    loadingSpinner,
  ];
}

/// Caching durations for different data types.
/// Optimizes performance and reduces API calls.
class CacheConstants {
  /// Cache durations
  static const int headlineCacheDuration = 300; // 5 minutes
  static const int trendingCacheDuration = 900; // 15 minutes
  static const int categoryCacheDuration = 86400; // 24 hours
  static const int sourceCacheDuration = 3600; // 1 hour
  static const int userProfileCacheDuration = 1800; // 30 minutes
  static const int searchResultsCacheDuration = 300; // 5 minutes
  
  /// Cache size limits
  static const int maxCachedHeadlines = 100;
  static const int maxCachedSearches = 20;
  static const int maxCachedSources = 50;
  static const int maxCacheSize = 50 * 1024 * 1024; // 50MB total cache size
  
  /// Cache management
  static const String cacheVersionKey = 'cache_version';
  static const Duration cleanupInterval = Duration(hours: 6);
  static const double cacheEvictionThreshold = 0.9; // 90% full triggers cleanup
  
  /// Cache priorities (1-10, 10 being highest)
  static const Map<String, int> cachePriorities = {
    'headlines': 10,
    'trending': 9,
    'sources': 8,
    'categories': 7,
    'search': 6,
    'user': 5,
  };
  
  /// Cache strategies
  static const bool enableOfflineCache = true;
  static const int maxOfflineDuration = 24 * 60 * 60; // 24 hours
  static const int backgroundSyncInterval = 15 * 60; // 15 minutes
  
  /// Cache invalidation triggers
  static const List<String> invalidationEvents = [
    'version_update',
    'user_logout',
    'force_refresh',
    'network_restored',
  ];
  
  /// Cache performance settings
  static const int compressionThreshold = 1024; // Compress items larger than 1KB
  static const bool enablePrefetching = true;
  static const int prefetchLimit = 10;
  
  /// Cache monitoring
  static const Duration monitoringInterval = Duration(minutes: 5);
  static const double healthThreshold = 0.95; // 95% cache hit rate threshold
}

/// Pagination settings for list views.
/// Ensures consistent data loading across platforms.
class PaginationConstants {
  /// Default number of items per page
  static const int defaultPageSize = 20;

  /// Maximum allowed items per page
  static const int maxPageSize = 25;

  /// Default starting page number
  static const int defaultPage = 1;

  /// Number of items to fetch when near end of list (prefetch threshold)
  static const int prefetchThreshold = 5;

  /// Maximum pages to keep in memory
  static const int maxPagesInMemory = 5;

  /// Different page sizes for specific views
  static const int trendingPageSize = 10;
  static const int searchPageSize = 15;
  static const int sourceFeedPageSize = 20;
  static const int categoryPageSize = 25;
  static const int bookmarksPageSize = 30;

  /// View modes with corresponding page sizes
  static const Map<String, int> viewModePageSizes = {
    'grid': 12,
    'list': 20,
    'compact': 30,
  };

  /// Scroll behavior settings
  /// Used for infinite scrolling and lazy loading
  static const double scrollThreshold = 0.8;
  static const int throttleTime = 500;
  /// Scroll velocity threshold for animations
  static const double velocityThreshold = 0.5; 
  /// Animation duration for scroll actions
  static const Duration animationDuration = Duration(milliseconds: 300);

  /// Performance settings
  /// Used to optimize data loading and rendering
  static const int maxTotalItems = 500;
  /// Number of items to load per batch in infinite scroll
  static const int itemsPerBatch = 10;
  /// Refresh threshold for pull-to-refresh actions
  static const int refreshThreshold = 50;
  /// Cooldown period for refresh actions
  static const Duration refreshCooldown = Duration(seconds: 30);
  
  /// Load states
  static const int initialLoadCount = 20; // Initial load count
  /// Load more offset for infinite scroll
  static const double loadMoreOffset = 200.0;
  /// Maximum retry
  static const int retryLimit = 3; 
  /// Retry delay duration
  static const Duration retryDelay = Duration(seconds: 2);
}

/// Date and time formatting patterns.
/// Ensures consistent datetime display across the app.
class DateTimeFormats {
  /// Format for displaying dates to users
  static const String displayFormat = 'MMM dd, yyyy';

  /// Format for API date/time operations
  static const String apiFormat = 'yyyy-MM-dd\'T\'HH:mm:ss\'Z\'';
  
  /// Format for displaying recent dates (today, yesterday)
  static const String recentFormat = 'h:mm a';
  
  /// Format for displaying dates within current year
  static const String currentYearFormat = 'MMM dd';
  
  /// Format for displaying full datetime
  static const String fullDateTime = 'MMM dd, yyyy h:mm a';
  
  /// Format for displaying time only
  static const String timeOnly = 'HH:mm';
  
  /// Format for displaying relative time (e.g., "2 hours ago")
  static const List<String> relativeTimeThresholds = [
    'just now',    // < 1 minute
    'minutes ago', // < 1 hour
    'hours ago',   // < 1 day
    'yesterday',   // < 2 days
    'days ago',    // < 1 week
    'weeks ago',   // < 1 month
    'months ago',  // < 1 year
  ];
  
  /// Format for RSS feed dates
  static const String rssFormat = 'EEE, dd MMM yyyy HH:mm:ss Z';
  
  /// Format for file naming (no spaces or special chars)
  static const String fileNameFormat = 'yyyyMMdd_HHmmss';
  
  /// Format for displaying dates in compact form
  static const String compactDate = 'dd/MM/yy';
  
  /// Format for week display
  static const String weekFormat = 'EEEE'; // Full weekday name
  
  /// Format for month display
  static const String monthFormat = 'MMMM yyyy'; // Full month and year
}

/// Search-related configurations and limitations.
/// Controls search behavior and performance.
class SearchConstants {
  /// Minimum length for search queries
  static const int minSearchLength = 3;

  /// Maximum length for search queries
  static const int maxSearchLength = 50;

  /// Maximum number of recent searches to store
  static const int searchHistoryLimit = 10;

  /// Debounce duration for search input in milliseconds
  static const int searchDebounceTime = 300;

  /// Maximum age of search history items in days
  static const int searchHistoryMaxAge = 30;

  /// Maximum number of search suggestions to show
  static const int maxSearchSuggestions = 5;

  /// Search modes
  static const String modeAll = 'all';
  static const String modeHeadlines = 'headlines';
  static const String modeSources = 'sources';
  static const String modeCategories = 'categories';

  /// Minimum search relevance score (0.0 to 1.0)
  static const double minimumRelevanceScore = 0.3;

  /// Default search sort options
  static const String sortRelevance = 'relevance';
  static const String sortDate = 'date';
  static const String sortPopularity = 'popularity';

  /// Search result grouping options
  /// Group search results by category or source if count exceeds threshold
  static const int groupResultsThreshold = 3;
  /// Maximum number of items to group in search results
  static const int maxGroupSize = 5;

  /// Search filters
  static const String filterToday = 'today';
  static const String filterWeek = 'week';
  static const String filterMonth = 'month';
  static const String filterYear = 'year';
}

/// News source management configurations.
/// Controls source handling and updates.
class SourceConstants {
  /// Maximum number of sources a user can follow
  static const int maxSourcesPerUser = 50;

  /// Interval between source content updates
  static const Duration sourceRefreshInterval = Duration(hours: 1);

  /// Maximum number of headlines per source
  static const int maxHeadlinesPerSource = 100;

  /// Minimum update frequency for source validation
  static const Duration sourceValidationInterval = Duration(days: 7);

  /// Maximum inactive period before source is marked dormant
  static const Duration sourceDormancyThreshold = Duration(days: 30);

  /// Maximum number of failed fetches before source is flagged
  static const int maxFailedFetches = 5;

  /// Timeout for source feed fetching
  static const Duration sourceFetchTimeout = Duration(seconds: 10);

  /// Maximum age of headlines to keep from source
  static const Duration headlineRetentionPeriod = Duration(days: 7);

  /// Maximum number of categories per source
  static const int maxSourceCategories = 3;

  /// Required minimum successful fetch rate (0.0 to 1.0)
  static const double minimumFetchSuccessRate = 0.8;

  /// Cool-down period after source is blocked
  static const Duration sourceBlockCooldown = Duration(days: 14);

  /// Source health check statuses

  /// Source is actively providing headlines and passing health checks
  static const String statusActive = 'active';

  /// Source hasn't provided new headlines for [sourceDormancyThreshold] period
  static const String statusDormant = 'dormant';

  /// Source is blocked due to failed health checks or policy violations
  static const String statusBlocked = 'blocked';

  /// Source is awaiting initial validation or revalidation
  static const String statusPending = 'pending';
}
