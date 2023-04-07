VERSION 0.6

# This allows one to change the running Ruby version with:
#
# `earthly --allow-privileged +rspec --EARTHLY_RUBY_VERSION=3`
ARG EARTHLY_RUBY_VERSION=2.7

FROM ruby:$EARTHLY_RUBY_VERSION
WORKDIR /gem

deps:
    RUN apt update \
        && apt install --yes \
                       --no-install-recommends \
                       build-essential \
                       git

dev:
    FROM +deps

    COPY Gemfile* /gem/

    IF [ $(dpkg --compare-versions "$EARTHLY_RUBY_VERSION" "gt" "2.6" && echo "true" || echo "false") = "true" ]
        RUN echo "Using $(bundle --version) ..."
    ELSE
        ARG BUNDLER_VERSION=$(grep -A 1 \"BUNDLED WITH\" Gemfile.lock | tail -n1 | awk \"{print $1}\")
        RUN echo "Installing Bundler $BUNDLER_VERSION ..." && gem install bundler --version $BUNDLER_VERSION
    END

    COPY *.gemspec /gem/
    RUN bundle install --jobs $(nproc)

    COPY .rubocop.yml /gem/
    COPY Rakefile /gem/
    COPY lib/ /gem/lib/
    COPY spec/ /gem/spec/

    ENTRYPOINT ["bundle", "exec"]
    CMD ["rake"]

    SAVE IMAGE juseveno/sms_factor:latest

#
# This target runs Rubocop.
#
# Use the following command in order to run the tests suite:
# earthly --allow-privileged +rubocop
rubocop:
    FROM earthly/dind:alpine

    COPY docker-compose-earthly.yml ./

    WITH DOCKER --load juseveno/sms_factor:latest=+dev
        RUN docker-compose -f docker-compose-earthly.yml run --rm gem rubocop
    END

#
# This target runs the test suite.
#
# Use the following command in order to run the tests suite:
# earthly --allow-privileged +rspec
rspec:
    FROM earthly/dind:alpine

    COPY docker-compose-earthly.yml ./

    WITH DOCKER --load juseveno/sms_factor:latest=+dev
        RUN docker-compose -f docker-compose-earthly.yml run --rm gem
    END

#
# This target is used to publish this gem to rubygems.org.
#
# Prerequiries
# You should have login against Rubygems.org so that it has created
# the `~/.gem` folder and stored your API key.
#
# Then use the following command:
# earthly +gem --GEM_CREDENTIALS="$(cat ~/.gem/credentials)" --RUBYGEMS_OTP=123456
gem:
    FROM +dev

    ARG GEM_CREDENTIALS
    ARG RUBYGEMS_OTP

    COPY .git/ /gem/
    COPY LICENSE /gem/
    COPY README.md /gem/

    RUN gem build sms_factor.gemspec \
        && mkdir ~/.gem \
        && echo "$GEM_CREDENTIALS" > ~/.gem/credentials \
        && cat ~/.gem/credentials \
        && chmod 600 ~/.gem/credentials \
        && gem push --otp $RUBYGEMS_OTP sms_factor-*.gem

    SAVE ARTIFACT sms_factor-*.gem AS LOCAL ./sms_factor.gem
