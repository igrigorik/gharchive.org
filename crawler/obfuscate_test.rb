require "test/unit"

require_relative "obfuscate.rb"

class ObfuscateEmail < Test::Unit::TestCase
    def test_empty_object
        input = {}
        got = Obfuscate.email(input)
        assert_equal input, got, "expect no change"
    end

    def test_email_obfuscation_for_simple_object
        input = {
            "email" => "example@gharchive.org"
        }
        Obfuscate.email(input)
        want = {
            "email" => "c3499c2729730a7f807efb8676a92dcb6f8a3f8f@gharchive.org"
        }
        assert_equal want, input, "expect no change"
    end

    def test_email_obfuscation_for_empty_email
        input = {
            "email" => ""
        }
        Obfuscate.email(input)
        assert_equal input, input, "expect no change"
    end

    def test_email_obfuscation_for_nested_fields
        input = {
            "email" => "example@gharchive.org",
            "friends" => [
                {
                    "email" => "1@gharchive.org"
                },
                {
                    "email" => "2@gharchive.org"
                }
            ]
        }
        Obfuscate.email(input)
        want = {
            "email" => "c3499c2729730a7f807efb8676a92dcb6f8a3f8f@gharchive.org",
            "friends" => [
                {
                    "email" => "356a192b7913b04c54574d18c28d46e6395428ab@gharchive.org"
                },
                {
                    "email" => "da4b9237bacccdf19c0760cab7aec4a8359010b0@gharchive.org"
                }
            ]
        }
        assert_equal want, input, "expect no change"
    end

    def test_no_obfuscation_for_other_files
        input = {
            "other" => "example@gharchive.org",
            "array-empty" => [],
            "array-string" => [
                "example string array"
            ],
            "string" => "example string",
            "number" => 123,
            "object" => {},

        }
        Obfuscate.email(input)
        assert_equal input, input, "expect no change"
    end
  end