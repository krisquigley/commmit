# frozen_string_literal: true

MeiliSearch.configuration = {
  meilisearch_api_key: ENV.fetch('MEILI_MASTER_KEY'),
  meilisearch_host: ENV.fetch('MEILI_HTTP_ADDR')
}
