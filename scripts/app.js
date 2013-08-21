(function() {
  window.PIG = {};

  PIG.Controller = {};

  PIG.Model = {};

  PIG.Collection = {};

  PIG.View = {};

}).call(this);

(function() {
  var __slice = [].slice;

  PIG.Controller.Base = (function() {
    function Base() {
      var attr;
      attr = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      this.initialize.apply(this, attr);
    }

    Base.prototype.initialize = function() {};

    return Base;

  })();

  _.extend(PIG.Controller.Base.prototype, Backbone.Events);

}).call(this);

(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  PIG.Controller.Frames = (function(_super) {
    __extends(Frames, _super);

    function Frames() {
      _ref = Frames.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Frames.prototype.initialize = function(attrs) {
      var _this = this;
      this.collection = this.coll = {};
      this._makeAttrs(attrs);
      return _.each(this.frameAttrs, function(obj, key) {
        _this.coll[key] = new PIG.Collection.Frames(obj.paths);
        return _this.coll[key].setName(obj.name);
      });
    };

    Frames.prototype._makeAttrs = function(attrs) {
      var _this = this;
      this.frameAttrs = {};
      this.paths = (function() {
        var ret;
        ret = [];
        _.each(attrs, function(val, key) {
          return ret.push(key);
        });
        return ret;
      })();
      return _.each(this.paths, function(attr) {
        return _this.frameAttrs[attr] = {
          name: attrs[attr].name,
          paths: (function() {
            var ret;
            ret = [
              {
                path: attr
              }
            ];
            _.map(_this.paths, function(path) {
              return ret.push({
                path: "" + attr + "_" + path
              });
            });
            return ret;
          })()
        };
      });
    };

    return Frames;

  })(PIG.Controller.Base);

}).call(this);

(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  PIG.Controller.Puzz = (function(_super) {
    __extends(Puzz, _super);

    function Puzz() {
      _ref = Puzz.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Puzz.prototype.initialize = function() {
      this.$select = $('.mod-select');
      this.view = {};
      this.frames = new PIG.Controller.Frames({
        flame: {
          name: '火'
        },
        water: {
          name: '水'
        },
        stone: {
          name: '木'
        },
        light: {
          name: '光'
        },
        dark: {
          name: '闇'
        },
        sexy: {
          name: '回復'
        }
      });
      this.view.appFrame = new PIG.View.AppFrame(this.frames.coll);
      return this.render();
    };

    Puzz.prototype.render = function() {
      return this.$select.html(this.view.appFrame.$el);
    };

    return Puzz;

  })(PIG.Controller.Base);

}).call(this);

(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  PIG.Model.Frame = (function(_super) {
    __extends(Frame, _super);

    function Frame() {
      _ref = Frame.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Frame.prototype._DIR = 'images/';

    Frame.prototype._PREFIX = 'pazu_frame_';

    Frame.prototype._EXTENSION = '.png';

    Frame.prototype.defaults = {
      path: null,
      imgPath: null
    };

    Frame.prototype.initialize = function() {
      return this.set({
        imgPath: "" + this._DIR + this._PREFIX + (this.get('path')) + this._EXTENSION
      });
    };

    return Frame;

  })(Backbone.Model);

}).call(this);

(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  PIG.Collection.Frames = (function(_super) {
    __extends(Frames, _super);

    function Frames() {
      _ref = Frames.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Frames.prototype.model = PIG.Model.Frame;

    Frames.prototype.setName = function(name) {
      return this.name = "" + name + "属性";
    };

    Frames.prototype.getName = function() {
      return this.name;
    };

    return Frames;

  })(Backbone.Collection);

}).call(this);

(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  PIG.View.AppFrame = (function(_super) {
    __extends(AppFrame, _super);

    function AppFrame() {
      _ref = AppFrame.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    AppFrame.prototype.tagName = 'div';

    AppFrame.prototype.className = 'mod-appFrame';

    AppFrame.prototype.events = {};

    AppFrame.prototype.initialize = function(frames) {
      this.child = {};
      this.child.fileSelect = new PIG.View.FileSelect();
      this.child.frames = new PIG.View.Frames(frames);
      return this.render();
    };

    AppFrame.prototype.render = function() {
      return this.$el.append(this.child['fileSelect'].$el, this.child['frames'].$el);
    };

    return AppFrame;

  })(Backbone.View);

}).call(this);

(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  PIG.View.FileSelect = (function(_super) {
    __extends(FileSelect, _super);

    function FileSelect() {
      _ref = FileSelect.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    FileSelect.prototype.className = 'mod-fileSelect';

    FileSelect.prototype.events = {
      'change input': '_onChangeFile'
    };

    FileSelect.prototype.initialize = function() {
      return this.render();
    };

    FileSelect.prototype.render = function() {
      return this.$el.html(_.template(this.temp));
    };

    FileSelect.prototype._onChangeFile = function(ev) {
      var $file;
      $file = $(ev.target).closest('input');
      return console.log($file.val());
    };

    FileSelect.prototype.temp = "<div class=\"mod-dropArea\">\n  <p>1. 画像ファイルを選択するか、このエリアにドラッグドロップしてください。</p>\n  <p>2. 属性フレームが表示されるので、好きな属性を選択してください。</p>\n  <p>3. Downloadボタンをクリック（タップ）してください。</p>\n  <p><input type=\"file\"></p>\n</div>";

    return FileSelect;

  })(Backbone.View);

}).call(this);

(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  PIG.View.Frames = (function(_super) {
    __extends(Frames, _super);

    function Frames() {
      _ref = Frames.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Frames.prototype.events = {
      'click input': '_onClickRadio'
    };

    Frames.prototype.initialize = function(frames) {
      return this.render(frames);
    };

    Frames.prototype.render = function(frames) {
      return this.$el.html(_.template(this.temp, {
        attrs: frames
      }));
    };

    Frames.prototype.hide = function() {
      return this.$el.hide();
    };

    Frames.prototype.show = function() {
      return this.$el.show();
    };

    Frames.prototype._onClickRadio = function(ev) {
      var $input;
      $input = $(ev.target).closest('input');
      return console.log($input.attr('value'));
    };

    Frames.prototype.temp = "<% _.each(attrs, function(coll, key) { %>\n<p class=\"mod-alt\"><%= coll.getName() %></p>\n<ul class=\"mod-frames\">\n  <% coll.each(function(model) { %>\n  <li class=\"mod-frame\">\n    <label>\n      <input type=\"radio\"\n        name=\"frame\"\n        value=\"<%= model.get('imgPath') %>\"><br>\n      <img src=\"<%= model.get('imgPath') %>\" width=\"35\">\n    </label>\n  </li>\n  <% }); %>\n</ul>\n<% }); %>";

    return Frames;

  })(Backbone.View);

}).call(this);
