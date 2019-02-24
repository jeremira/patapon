# Livestorm Backend test
 
Création d'une route d'API, permettant, dans un premier temps, de sauvegarder un Utilisateur en base; et, dans un second, d'envoyer ses données sur le service [Hubspot](https://www.hubspot.com/) (pour lequel il faut préalablement créer un compte), tout en lui rattachant une Note (contenu libre).

#### Points d'importance

- L'action de contacter le service Hubspot ne doit pas bloquer l'exécution de la requête.

- Les interactions avec la librairie Hubspot doivent être encapsulées et réutilisable au sein du projet.

- Tous les differents cas d'interaction avec la librairie Hubspot doivent etre prévus et testés en isolation.

- Un utilisateur doit absoluement avoir une fiche Hubspot créée.

- Dans "Hubspot > Sales > Contacts", on doit pouvoir voir cet utilisateur ainsi que la note attachée.

#### Resources Suggerées

- [Hubspot](https://github.com/adimichele/hubspot-ruby)
- [Sidekiq](https://github.com/mperham/sidekiq)
- [Rspec](https://github.com/rspec/rspec-rails)
- [ShouldaMatchers](https://github.com/thoughtbot/shoulda-matchers)
- [Rubocop](https://github.com/bbatsov/rubocop)
- [Webmock](https://github.com/bblimke/webmock)
- [Timecop](https://github.com/travisjeffery/timecop)
- [VCR](https://github.com/vcr/vcr)
- [FactoryBot](https://github.com/thoughtbot/factory_bot)
