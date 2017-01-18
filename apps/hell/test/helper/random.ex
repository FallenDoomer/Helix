defmodule HELL.TestHelper.Random do

  alias HELL.TestHelper.Random.Alphabet
  alias HELL.TestHelper.Random.Alphabet.Alphanum
  alias HELL.TestHelper.Random.Alphabet.Digits

  import HELL.MacroHelpers

  @type string_params :: [
    {:min, integer},
    {:max, integer},
    {:length, integer}]

  # AKA int(2^27)... The range is good enough and is 32-bit compatible int (non-big)
  @default_number trunc(:math.pow(2, 27))

  # A few TLDs to be used when building a random hostname (no particular order
  # or reason on the specific choices, just wanted a few common, a few composite
  # and, few with utf8 characters and a few long)
  @tlds ~w/.com .net .com.br .co.uk .org .info .us .gov .mil .br .me .au .中国
    .ελ .blackfriday .cam .club .codes .coffee .download .email .moe .ninja
    .international .scholarships .travelersinsurance .vermögensberatung/

  def pk do
    Burette.Network.ipv6()
  end

  @spec number() :: integer
  @doc """
  Returns a random number between `-#{@default_number}` and `#{@default_number}`
  """
  def number,
    do: number(-@default_number..@default_number)

  @spec number(Range.t) :: integer
  @doc """
  Returns a random number between `m` and `n`

  Can be used as `number(m..n)` or `number(min: m, max: n)` in the latter case
  one param is optional and will default to `#{@default_number}`

  ## Examples
  ```
      number(0..10)

      number(-10..0)

      number(-255..255)

      number(min: 0)

      number(min: -255)

      number(max: 0)

      number(min: -1, max: 1)
  ```
  """
  def number(m..n) do
    ((n - m + 1) * :rand.uniform() + m)
    |> Float.floor()
    |> trunc()
  end

  def number(params = [_|_]) do
    min = Keyword.get(params, :min, -@default_number)
    max = Keyword.get(params, :max, @default_number)

    number(min..max)
  end

  @spec digits(string_params) :: String.t
  @doc """
  Same as `string(alphabet: Digits.alphabet)`
  """
  def digits(params \\ []),
    do: params |> Keyword.put(:alphabet, Digits.alphabet()) |> string()

  @spec string(string_params) :: String.t
  @doc """
  Produces a random string

  `params` accept
  - `:min` the minimum length of the string, defaults to 1 and is ignored if
  `:length` is provided
  - `:max` the maximum length of the string, defaults to 20 and is ignored if
  `:length` is provided
  - `:length` the exact length the string must have
  - `:alphabet` the alphabet that should be used to generate the string. Defaults
  to `HELL.TestHelper.Random.Alphabet.Alphanum.alphabet/0`. You can provide
  other alphabet or build your own using `HELL.TestHelper.Random.Alphabet.build_alphabet/1`

  ## Example
  ```
      string()
      # Random alphanumeric string with 1 to 20 characters

      string(min: 10)
      # Random alphanumeric string with 10 to 20 characters

      string(min: 50, max: 500)
      # Random alphanumeric string with 50 to 500 characters

      string(length: 20)
      # Random alphanumeric string with 20 characters

      string(length: 10, alphabet: HELL.TestHelper.Random.Alphabet.Digits.alphabet)
      # Random string with 10 characters composed solely of digits

      alphabet = ~w/a b c/ |> HELL.TestHelper.Random.Alphabet.build_alphabet()
      string(alphabet: alphabet)
      # Random string with 1 to 20 characters in the range of ["a", "b", "c"]

      alphabet = "IRMB" |> HELL.TestHelper.Random.Alphabet.build_alphabet()
      string(alphabet: alphabet, length: 1)
      # Random string with 1 character in the range of ["I", "R", "M", "B"]
  ```
  """
  def string(params \\ []) do
    min = Keyword.get(params, :min, 1)
    max = Keyword.get(params, :max, 20)
    length = Keyword.get(params, :length, number(min..max))
    alphabet = Keyword.get(params, :alphabet, Alphanum.alphabet())

    if 0 === length do
      ""
    else
      for _ <- 1..length, into: "",
        do: random_char(alphabet)
    end
  end

  @email_sep_alphabet Alphabet.build_alphabet("._-+")
  @doc """
  Generates a random valid email

  Note that the random emails are very simple and thus are not ideal to check if
  an email validator is RFC-compliant

  `params` is a proplist whose accepted values are:
  - `hostname` the hostname part of the email. if none is provided, a random is
  is generated by `hostname/0`
  """
  def email(params \\ []) do
    hostname = Keyword.get(params, :hostname, hostname())

    build_email_part = fn ->
      random_char(@email_sep_alphabet) <> string(max: 10)
    end

    email_part = string(min: 3) <> Enum.join(repeat(build_email_part, min: 0, max: 5))

    email_part <> "@" <> hostname
  end

  @doc """
  Generates a random hostname
  """
  def hostname do
    name = Enum.join(repeat(fn -> string(min: 2, max: 10) end, min: 1, max: 4), ".")

    name <> Enum.random(@tlds)
  end

  @doc """
  Repeats `function` several times

  You can provide params like `min`, `max` and `times`.
  - `times` means how many times you want the do block to be re-evaluated
  - `min` is the minimum times the block should be re-evaluated (defaults
  to 10 and is ignored if `times` is provided)
  - `max` is the maximum times the block should be re-evaluated (defaults
  to 20 and is ignored if `times` is provided)

  Note that the code inside the function will be executed several times and it's
  value is returned as a list at the end

  ## Example
  ```
      function = fn ->
        email = random_email()
        assert valid_email?(email)
      end
      repeat function, times: 300


      function = fn -> :ok end
      repeat function, times: 100
      # [:ok, :ok, :ok, :ok, ...]


      function = fn ->
        password = valid_password_including_cool_emoji()
        assert valid_password?(password)
      end
      repeat function min: 100, max: 10_000

      list_of_random_floats = repeat fn ->
        :random.uniform()
      end

      assert Enum.all?(list_of_random_floats, &(&1 >= 0 and &1 <= 1))


      emoji_alphabet = Alphabet.build_alphabet(["🔙", "🔚", "🔝"])
      function = fn ->
        user_name = string(alphabet: emoji_alphabet, min: 3, max: 100)
        assert is_binary(user_name)
      end
      repeat function
  ```
  """
  def repeat(function, params \\ []) do
    min = Keyword.get(params, :min, 10)
    max = Keyword.get(params, :min, 20)
    times = Keyword.get(params, :times, number(min..max))

    if 0 === times do
      []
    else
      for _ <- 1..times do
        function.()
      end
    end
  end

  docp """
  Fetches a random letter from an alphabet
  """
  defp random_char(%Alphabet{size: s, characters: c}),
    do: Map.fetch!(c, number(0..s))
end