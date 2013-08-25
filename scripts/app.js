(function() {
  window.PIG = {};

  PIG.Controller = {};

  PIG.Model = {};

  PIG.Collection = {};

  PIG.View = {};

  PIG.events = {};

  _.extend(PIG.events, Backbone.Events);

  PIG.isMobile = function() {
    var ua;
    ua = navigator.userAgent;
    if (/iPhone|iPad|Android/.test(ua)) {
      return true;
    }
    return false;
  };

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

    Frames.prototype.initialize = function(frames) {
      var _this = this;
      this.collection = this.coll = {};
      this._makeAttrs(frames);
      return _.each(this.frameAttrs, function(obj, key) {
        _this.coll[key] = new PIG.Collection.Frames(obj.paths);
        return _this.coll[key].setName(obj.name);
      });
    };

    Frames.prototype._makeAttrs = function(frames) {
      var _this = this;
      this.frameAttrs = {};
      this.paths = _.pluck(frames, 'attr');
      this.attrs = (function() {
        var ret;
        ret = {};
        _.each(frames, function(val) {
          return ret[val.attr] = val;
        });
        return ret;
      })();
      return _.each(this.paths, function(attr) {
        return _this.frameAttrs[attr] = {
          name: _this.attrs[attr].name,
          paths: (function() {
            var ret;
            ret = [
              {
                path: attr
              }
            ];
            _.each(_this.paths, function(path) {
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

    Puzz.prototype.FRAMES = [
      {
        name: '火',
        attr: 'flame'
      }, {
        name: '水',
        attr: 'water'
      }, {
        name: '木',
        attr: 'stone'
      }, {
        name: '光',
        attr: 'light'
      }, {
        name: '闇',
        attr: 'dark'
      }, {
        name: '回復',
        attr: 'sexy'
      }
    ];

    Puzz.prototype.initialize = function() {
      this.$select = $('.mod-select');
      this.view = {};
      this.frames = new PIG.Controller.Frames(this.FRAMES);
      this.view.appFrame = new PIG.View.AppFrame(this.frames.coll);
      this.render();
      return this._eventify();
    };

    Puzz.prototype._eventify = function() {
      var appFrame, events,
        _this = this;
      events = PIG.events;
      appFrame = this.view.appFrame;
      this.listenTo(events, 'select:file', function(file) {
        return appFrame.setFile(file);
      });
      this.listenTo(events, 'select:frame', function(frame) {
        return appFrame.selectFrame(frame);
      });
      this.listenTo(events, 'set:fitScale', function(isSet) {
        return appFrame.setFitScale(isSet);
      });
      this.listenTo(events, 'set:scale', function(scale) {
        return appFrame.setScale(scale);
      });
      this.listenTo(events, 'set:frame', function(frame) {
        return appFrame.setFrame(frame);
      });
      return this.listenTo(events, 'create:file', function(data) {
        return appFrame.setDownload(data);
      });
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

    Frame.prototype.DIR = 'images/';

    Frame.prototype.PREFIX = 'pazu_frame_';

    Frame.prototype.EXTENSION = '.png';

    Frame.prototype.defaults = {
      path: null,
      imgPath: null
    };

    Frame.prototype.initialize = function() {
      return this.set({
        imgPath: "" + this.DIR + this.PREFIX + (this.get('path')) + this.EXTENSION
      });
    };

    return Frame;

  })(Backbone.Model);

}).call(this);

(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  PIG.Model.Preview = (function(_super) {
    __extends(Preview, _super);

    function Preview() {
      _ref = Preview.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Preview.prototype.defaults = {
      type: 'image/png',
      isFitScale: false,
      scale: 1,
      iconSrc: null,
      iconBaseWidth: null,
      iconBaseHeight: null,
      iconBaseImage: null,
      iconPos: {
        x: 0,
        y: 0
      },
      frameSrc: null,
      iconFrameImage: null
    };

    return Preview;

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

    AppFrame.prototype.initialize = function(frames) {
      this.preview = new PIG.View.Preview();
      this.fileSelect = new PIG.View.FileSelect();
      this.frames = new PIG.View.Frames(frames);
      return this.render();
    };

    AppFrame.prototype.render = function() {
      return this.$el.append(this.fileSelect.$el, this.preview.$el, this.frames.$el, this.$link = $(this.tmpLinkInavtive));
    };

    AppFrame.prototype.renderLink = function(file) {
      return this.$link.html(_.template(this.tmpLinkActive, file));
    };

    AppFrame.prototype.setFile = function(file) {
      return this.preview.setFile(file);
    };

    AppFrame.prototype.selectFrame = function(frame) {
      return this.preview.selectFrame(frame);
    };

    AppFrame.prototype.setFrame = function(frame) {
      return this.preview.setFrame(frame);
    };

    AppFrame.prototype.setFitScale = function(isFit) {
      return this.preview.setFitScale(isFit);
    };

    AppFrame.prototype.setScale = function(scale) {
      return this.preview.setScale(scale);
    };

    AppFrame.prototype.setDownload = function(file) {
      return this.renderLink(file);
    };

    AppFrame.prototype.tmpLinkInavtive = "<p class=\"mod-download\">\n  <a href=\"javascript:void(0)\"\n     class=\"mod-download-link\"\n  >ダウンロードする</a>\n</p>";

    AppFrame.prototype.tmpLinkActive = "<a href=\"<%= href %>\"\n   download=\"<%= fileName %>\"\n   target=\"_blank\"\n   class=\"mod-download-link state-active\"\n>ダウンロードする</a>";

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
      'change input[type="file"]': '_onChangeFile',
      'click input[type="checkbox"]': '_onClickCheckbox',
      'drop': '_onDrop',
      'dragenter': '_onDragEnter',
      'dragover': '_onDragOver'
    };

    FileSelect.prototype.initialize = function() {
      return this.render();
    };

    FileSelect.prototype._onDrop = function(ev) {
      var data, file, files;
      ev.stopPropagation();
      ev.preventDefault();
      ev = ev.originalEvent;
      data = ev != null ? ev.dataTransfer : void 0;
      files = data != null ? data.files : void 0;
      file = files != null ? files[0] : void 0;
      if (!file) {
        return;
      }
      return PIG.events.trigger('select:file', file);
    };

    FileSelect.prototype._onDragEnter = function(ev) {
      return ev.preventDefault();
    };

    FileSelect.prototype._onDragOver = function(ev) {
      return ev.preventDefault();
    };

    FileSelect.prototype.render = function() {
      return this.$el.html(_.template(this.temp));
    };

    FileSelect.prototype._onChangeFile = function(ev) {
      var $file, file;
      $file = $(ev.target).closest('input');
      file = $file.get(0).files[0];
      return PIG.events.trigger('select:file', file);
    };

    FileSelect.prototype._onClickCheckbox = function(ev) {
      var $checkbox;
      $checkbox = $(ev.target).closest('input');
      return PIG.events.trigger('set:fitScale', $checkbox.is(':checked'));
    };

    FileSelect.prototype.temp = "<div class=\"mod-dropArea\">\n  <p><input type=\"file\"></p>\n  <p><label><input type=\"checkbox\"> 画像を枠にフィットさせる</label><p>\n</div>";

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

    Frames.prototype.className = 'mod-frames-wrapper';

    Frames.prototype.events = {
      'click input': '_onClickRadio'
    };

    Frames.prototype.initialize = function(frames) {
      var $defaultFrame, $defaultFramePath, $frames;
      this.render(frames);
      $frames = this.$el.find('.mod-frame');
      $defaultFrame = $frames.first().find('input').prop('checked', 'checked');
      $defaultFramePath = $defaultFrame.val();
      return _.defer(function() {
        return PIG.events.trigger('set:frame', $defaultFramePath);
      });
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
      return PIG.events.trigger('select:frame', $input.val());
    };

    Frames.prototype.temp = "<% _.each(attrs, function(coll, key) { %>\n<p class=\"mod-alt attr-<%= key %>\"><%= coll.getName() %></p>\n<ul class=\"mod-frames\">\n  <% coll.each(function(model) { %>\n  <li class=\"mod-frame\">\n    <label>\n      <input type=\"radio\"\n        name=\"frame\"\n        value=\"<%= model.get('imgPath') %>\"><br>\n      <img src=\"<%= model.get('imgPath') %>\" width=\"30\">\n    </label>\n  </li>\n  <% }); %>\n</ul>\n<% }); %>";

    return Frames;

  })(Backbone.View);

}).call(this);

(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  PIG.View.Preview = (function(_super) {
    __extends(Preview, _super);

    function Preview() {
      _ref = Preview.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Preview.prototype.tagName = 'div';

    Preview.prototype.className = 'mod-preview';

    Preview.prototype.CANVAS_SIZE = 98;

    Preview.prototype.initialize = function() {
      this.dragStart = false;
      this.model = new PIG.Model.Preview();
      this.render();
      this._initReader();
      this._initCanvas();
      this._eventify();
      return this.hide();
    };

    Preview.prototype.events = (function() {
      var events;
      if (PIG.isMobile()) {
        events = {
          'touchstart canvas': '_onDragStart',
          'touchmove  canvas': '_onDragMove',
          'touchend   canvas': '_onDragEnd'
        };
      } else {
        events = {
          'mousedown  canvas': '_onDragStart',
          'mousemove  canvas': '_onDragMove',
          'mouseup    canvas': '_onDragEnd'
        };
      }
      return _.extend(events, {
        'change input[type="range"]': '_onChangeRange'
      });
    })();

    Preview.prototype._eventify = function() {
      var _this = this;
      this.listenTo(this.model, 'change:isFitScale', function() {
        var e, isFitScale;
        isFitScale = _this.model.get('isFitScale');
        if (isFitScale) {
          _this._hideScaleBar();
        } else {
          _this._showScaleBar();
        }
        try {
          return _this._drawIcon();
        } catch (_error) {
          e = _error;
        }
      });
      this.listenTo(this.model, 'change:iconPos', function() {
        return _this._drawIcon();
      });
      this.listenTo(this.model, 'change:scale', function() {
        return _this._drawIcon();
      });
      this.listenTo(this.model, 'change:iconSrc', function(model, iconSrc) {
        return _this._loadImage(iconSrc, 'icon');
      });
      this.listenTo(this.model, 'change:frameSrc', function(model, frameSrc) {
        return _this._loadImage(frameSrc, 'frame');
      });
      return this.listenTo(this.model, 'set:image', function() {
        return this._drawIcon();
      });
    };

    Preview.prototype._initReader = function() {
      var _this = this;
      this.reader = new FileReader();
      return this.reader.addEventListener('load', function() {
        return _this._onLoadReader();
      }, false);
    };

    Preview.prototype._onLoadReader = function() {
      return this.model.set('iconSrc', this.reader.result);
    };

    Preview.prototype._getClientPos = function(ev) {
      var touches;
      ev = ev.originalEvent;
      touches = ev.touches;
      if (touches) {
        return {
          x: touches[0].clientX,
          y: touches[0].clientY
        };
      } else {
        return {
          x: ev.clientX,
          y: ev.clientY
        };
      }
    };

    Preview.prototype._onDragStart = function(ev) {
      if (this.model.get('isFitScale')) {
        return;
      }
      ev.preventDefault();
      this.dragStart = true;
      this.dragStartPos = {
        x: 0,
        y: 0
      };
      return this.dragStartEv = this._getClientPos(ev);
    };

    Preview.prototype._onDragMove = function(ev) {
      var dragDiff, dragEndPos, iconPos;
      ev.preventDefault();
      if (!this.dragStart) {
        return;
      }
      dragEndPos = this._getClientPos(ev);
      dragDiff = {
        x: dragEndPos.x - this.dragStartEv.x,
        y: dragEndPos.y - this.dragStartEv.y
      };
      iconPos = this.model.get('iconPos');
      this.model.set('iconPos', {
        x: iconPos.x + dragDiff.x,
        y: iconPos.y + dragDiff.y
      });
      return this.dragStartEv = dragEndPos;
    };

    Preview.prototype._onDragEnd = function(ev) {
      ev.preventDefault();
      if (!this.dragStart) {
        return;
      }
      return this.dragStart = false;
    };

    Preview.prototype._onChangeRange = function(ev) {
      var $range, def, max, min, scale, val;
      $range = $(ev.target).closest('input');
      min = $range.prop('min') || 0;
      max = $range.prop('max') || 100;
      def = max / 2;
      val = $range.val();
      scale = 5 <= val ? val - (def - 1) : 1 - ((5 - val) * (1 / def));
      return PIG.events.trigger('set:scale', scale || 0.02);
    };

    Preview.prototype._drawIcon = function() {
      var base, baseHeight, baseWidth, canvas, ctx, diffHeight, diffWidth, fitHeight, fitPosLeft, fitPosTop, fitWidth, frame, height, icon, iconPos, isLargerThanCanvas, movedX, movedY, scale, width, x, y;
      ctx = this.ctx;
      canvas = this.canvas;
      iconPos = this.model.get('iconPos');
      scale = this.model.get('scale') || 1;
      icon = this.model.get('iconBaseImage');
      width = this.model.get('iconBaseWidth');
      height = this.model.get('iconBaseHeight');
      frame = this.model.get('iconFrameImage');
      if (!icon || !frame) {
        return;
      }
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      isLargerThanCanvas = this.CANVAS_SIZE < width || this.CANVAS_SIZE < height;
      if (this.model.get('isFitScale') && isLargerThanCanvas) {
        base = width < height;
        if (base) {
          fitWidth = width * this.CANVAS_SIZE / height;
          fitHeight = this.CANVAS_SIZE;
          fitPosTop = 0;
          fitPosLeft = this.CANVAS_SIZE / 2 - fitWidth / 2;
        } else {
          fitWidth = this.CANVAS_SIZE;
          fitHeight = height * this.CANVAS_SIZE / width;
          fitPosTop = this.CANVAS_SIZE / 2 - fitHeight / 2;
          fitPosLeft = 0;
        }
        canvas.setAttribute('width', this.CANVAS_SIZE);
        canvas.setAttribute('height', this.CANVAS_SIZE);
        ctx.drawImage(icon, fitPosLeft, fitPosTop, fitWidth, fitHeight);
      } else {
        baseWidth = width;
        baseHeight = height;
        width = width * scale;
        height = height * scale;
        diffWidth = width - baseWidth;
        diffHeight = height - baseHeight;
        x = -diffWidth / 2;
        y = -diffHeight / 2;
        movedX = iconPos.x + x;
        movedY = iconPos.y + y;
        icon.setAttribute('width', width);
        icon.setAttribute('height', height);
        canvas.setAttribute('width', this.CANVAS_SIZE);
        canvas.setAttribute('height', this.CANVAS_SIZE);
        ctx.drawImage(icon, movedX, movedY, width, height);
      }
      ctx.drawImage(frame, 0, 0, this.CANVAS_SIZE, this.CANVAS_SIZE);
      return this._createFile();
    };

    Preview.prototype._loadImage = function(src, target) {
      var img, _onImgLoad,
        _this = this;
      img = document.createElement('img');
      _onImgLoad = function() {
        if (target === 'icon') {
          _this.model.set({
            iconBaseWidth: img.width,
            iconBaseHeight: img.height,
            iconBaseImage: img
          });
        } else {
          _this.model.set({
            iconFrameImage: img
          });
        }
        _this.model.trigger('set:image');
        img.removeEventListener('load', _onImgLoad);
        return img = null;
      };
      img.src = src;
      return img.addEventListener('load', _onImgLoad, false);
    };

    Preview.prototype._initCanvas = function() {
      this.canvas = document.createElement('canvas');
      this.canvas.setAttribute('class', 'mod-canvas-icon');
      this.$el.find('.mod-canvas').append(this.canvas);
      return this.ctx = this.canvas.getContext('2d');
    };

    Preview.prototype._createFile = function() {
      var dataURL, fileType;
      dataURL = this.canvas.toDataURL(this.model.get('type'));
      fileType = this.model.get('type').replace('image/', '') || 'png';
      return PIG.events.trigger('create:file', {
        href: dataURL,
        fileName: "puzzIconGen_" + (+(new Date)) + "_." + fileType
      });
    };

    Preview.prototype.render = function() {
      this.$el.append(this.temp);
      return this.$scaleBar = this.$el.find('.mod-scaleRange');
    };

    Preview.prototype.setFile = function(file) {
      this.model.set('type', file.type);
      this.reader.readAsDataURL(file);
      return this.show();
    };

    Preview.prototype.setFrame = function(frame) {
      return this.model.set('frameSrc', frame);
    };

    Preview.prototype.selectFrame = function(frame) {
      return this.model.set('frameSrc', frame);
    };

    Preview.prototype.setFitScale = function(isFit) {
      return this.model.set('isFitScale', isFit);
    };

    Preview.prototype.setScale = function(scale) {
      return this.model.set('scale', scale);
    };

    Preview.prototype.show = function() {
      return this.$el.show();
    };

    Preview.prototype.hide = function() {
      return this.$el.hide();
    };

    Preview.prototype._showScaleBar = function() {
      return this.$scaleBar.show();
    };

    Preview.prototype._hideScaleBar = function() {
      return this.$scaleBar.hide();
    };

    Preview.prototype.temp = "<div class=\"mod-canvas\"></div>\n<p class=\"mod-scaleRange\"><input type=\"range\" min=\"0\" max=\"10\" step=\"0.1\">アップロードした画像のサイズを調整できます。</p>";

    return Preview;

  })(Backbone.View);

}).call(this);
