# Validation for Elixir (Under development)

- [x] Ability to nest rules for nested structs
- [ ] Hooks before validation rules (normalizers?) (for example normalizes 2,55 to 2.55)

Integrations

- [ ] plug -> for validating http requests
- [ ] ecto -> to validate with database
- [ ] gettext -> error messages internationalization
 
## Rules (from Laravel)

- [x] Accepted
- [ ] Active URL
- [ ] After (Date)
- [ ] Alpha
- [ ] Alpha Dash
- [ ] Alpha Numeric
- [ ] Array
- [ ] Before (Date)
- [x] Between
- [ ] Boolean
- [ ] Confirmed
- [ ] Date
- [ ] Date Format
- [ ] Different
- [ ] Digits
- [ ] Digits Between
- [ ] Distinct
- [ ] E-Mail
- [ ] Exists (Database)
- [ ] Filled
- [ ] Image (File)
- [ ] In
- [ ] In Array
- [ ] Integer
- [ ] IP Address
- [ ] JSON
- [x] Max
- [ ] MIME Types (File)
- [x] Min
- [ ] Not In
- [ ] Numeric
- [ ] Present
- [ ] Regular Expression
- [ ] Required
- [ ] Required If
- [ ] Required Unless
- [ ] Required With
- [ ] Required With All
- [ ] Required Without
- [ ] Required Without All
- [ ] Same
- [ ] Size
- [ ] String
- [ ] Timezone
- [ ] Unique (Database)
- [ ] URL
- [x] Accepted

## Higher order rules

- [x] if_field -> if other field exists, or it has specific value, validate with some other rule.
- [ ] if_not_field -> reverse of if_field

Copyright and License

Copyright (c) 2016, Roberts Gulans.

Phoenix source code is licensed under the [MIT License](LICENSE.md).
