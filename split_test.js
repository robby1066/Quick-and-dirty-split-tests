(function() {
  window.SplitTest = (function() {
    SplitTest.prototype.current_variation = null;
    function SplitTest(name, variations, user_id) {
      var cookie, right_now, two_weeks_from_now;
      this.name = name;
      this.variations = variations != null ? variations : [];
      if (user_id == null) {
        user_id = null;
      }
      this.current_variation = this.get_query_string() || this.get_split_cookie();
      if (!(this.current_variation != null)) {
        if (user_id === null) {
          this.current_variation = this.variations[Math.floor(Math.random() * this.variations.length)];
        } else {
          this.current_variation = this.variations[user_id % this.variations.length];
        }
      }
      right_now = new Date();
      two_weeks_from_now = new Date(right_now.getTime() + (1000 * 60 * 60 * 24 * 14));
      cookie = 'split_' + this.name + '=' + this.current_variation;
      cookie += '; expires=' + two_weeks_from_now.toGMTString();
      cookie += ',path=/';
      document.cookie = cookie;
    }
    SplitTest.prototype.get_variation = function() {
      return this.current_variation;
    };
    SplitTest.prototype.has_variation = function(variation_name) {
      return this.current_variation === variation_name;
    };
    SplitTest.prototype.track_with_google_analytics = function(slot_number) {
      window._gaq = window._gaq || [];
      return window._gaq.push(["_setCustomVar", slot_number, this.name, this.current_variation, 1]);
    };
    SplitTest.prototype.get_split_cookie = function() {
      var cookie, cookies_raw, _i, _len, _ref;
      cookies_raw = ((_ref = document.cookie) != null ? _ref.split('; ') : void 0) || [];
      for (_i = 0, _len = cookies_raw.length; _i < _len; _i++) {
        cookie = cookies_raw[_i];
        cookie = cookie.split('=');
        if (cookie[0] === 'split_' + this.name) {
          return cookie[1];
        }
      }
    };
    SplitTest.prototype.get_query_string = function() {
      var query, _i, _len, _ref;
      _ref = window.location.search.replace('?', '').split('&');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        query = _ref[_i];
        query = query.split('=');
        if (query[0] === this.name) {
          return query[1];
        }
      }
    };
    return SplitTest;
  })();
}).call(this);
