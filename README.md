# Fencepost
[![Gem Version](https://badge.fury.io/rb/fencepost.png)](http://badge.fury.io/rb/fencepost)
[![Build Status](https://travis-ci.org/scotthelm/fencepost.png)](https://travis-ci.org/scotthelm/fencepost)
[![Code Climate](https://codeclimate.com/github/scotthelm/fencepost.png)](https://codeclimate.com/github/scotthelm/fencepost)

For Rails 4.x - Provides a simple method for creating strong parameter
configuration based on your ActiveRecord models, and using this configuration
in your controllers.

## Installation

Add `fencepost` to your `Gemfile`

    gem 'fencepost'

## Usage

The gem creates a `fencepost` method in your contollers. This returns a
`Fencepost` object that has read your models and given you access to strong
params for any ActiveRecord model in your application. e.g:

    # app/controllers/people_controller
    def create
      @person = Person.create(fencepost.person_params)
    end

## Why?

I was upgrading several applications from Rails 3.x and did not want to have to
write strong parameter declarations in all of my controllers. I got ruby to do
it for me.
