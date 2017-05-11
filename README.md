# Ip2country

IP2Country is a simple geolocating module (IP -> Country Code) with built-in database.

## Installation

The package can be installed
by adding `ip2country` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:ip2country, "~> 1.0.0"}]
end
```

## Usage
````elixir
iex> IP2Country.whereis("51.254.116.38")
:FR

iex> IP2Country.whereis("176.9.20.99")  
:DE

iex> IP2Country.whereis("83.144.118.166")
:PL
````

## Database

Database is provided by https://db-ip.com, and it is compiled into the module. Compilation time is about
20 seconds on 2-core machine.

To update the database, download it from https://db-ip.com/db/download/country, unzip and replace the file
located in `lib/db`.

The free IP-to-country database by [DB-IP](https://db-ip.com/db/download/country) is licensed under a
[Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/).

## Contact

(c)2016 Tomek "Grych" Gryszkiewicz, 
<grych@tg.pl>
