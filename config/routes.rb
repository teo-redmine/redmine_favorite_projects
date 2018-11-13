match 'favorite_projects/index',
      to: 'favorite_projects#index',
      via: [:get]
match 'favorite_projects/favorite',
      to: 'favorite_projects#favorite',
      via: [:get]
match 'favorite_projects/unfavorite',
      to: 'favorite_projects#unfavorite',
      via: [:get, :delete]
match 'favorite_projects/search',
      to: 'favorite_projects#search',
      via: [:get, :put, :post],
      as: 'search_favorite_projects'
