[v0.0.6 / 2015-03-19] (https://github.com/hendrauzia/rspec-authorization/tree/v0.0.6)
=====================

  * Fix travis build matrix
  * Add appraisal to test on multiple dependencies
  * Stub all before and after callback except filter_access_filter
  * Refactor resource initialization to use privilege class.
  * Refactor restful helper method actions and negated actions out of resource
  * Refactor permitted or forbidden into 2 separate permitted and forbidden methods
  * Refactor run all requests and permitted or forbidden to resource
  * Refactor actions, results and their negated counterparts to resource
  * Refactor actions and negated actions from have_permission_to to resource
  * Refactor restful helper method to resource class
  * Refactor multiple request running to a resource class
  * Refactor have permission for matcher
  * Refactor restful helper method initialization
  * Add focused restful helper method
  * Refactor restful helper method generation from method missing to a class
  * Refactor RESTful matcher method helper to use ruby's #method_missing
  * Add license and history information in README

[v0.0.2 / 2014-11-11] (https://github.com/hendrauzia/rspec-authorization/tree/v0.0.2)
=====================

  * Add RESTful methods matcher chaining
  * Add object, callback and controller action stub
  * Add documentation to have_permission_for matcher
  * Add request documentation
  * Refactor and add documentation to example
  * Refactor and add documentation to example group
  * Add documentation to gem requirement
  * Add documentation to route
  * Add yard as documentation generator
  * Add documentation badge
  * Add coverage, dependencies and security badges
  * Fix rails test app spec
  * Fix travis build
  * Add travis badge and config
  * Add gem version badge and usage

[v0.0.1 / 2014-11-05] (https://github.com/hendrauzia/rspec-authorization/tree/v0.0.1)
=====================

  * Add have_permission_for matcher for restful actions
  * Add rails test app template
  * Add clean and reset rake task
  * Update dependency to ruby 2.1.4
  * Add rails test app for spec to run against
  * Add rspec-rails for specs
  * Add rspec-authorization gem scaffold using bundler
  * Initial commit
