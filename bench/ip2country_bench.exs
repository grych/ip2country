defmodule IP2CountryBench do
  use Benchfella

  bench "ip to country code" do
    IP2Country.whereis("148.81.83.81")
  end
  
end
