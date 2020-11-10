# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Scrapper.Repo.insert!(%Scrapper.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
["gyapu.com", "sastodeal.com", "daraz.com", "infi.store", "smartdoko.com"]
|> Enum.each(&Scrapper.Query.DataSource.create_data_source(%{name: &1}))
