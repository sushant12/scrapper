import_file_if_available("~/.iex.exs")

alias Scrapper.Repo

alias Scrapper.Schema.{
  DataSources,
  Items,
  Price
}

alias Scrapper.Query.{
  DataSource,
  Item
}
