// Licensed to Cloudera, Inc. under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  Cloudera, Inc. licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

var FileViewerModel = (function (path, baseUrl) {
  function formatHex(number, padding) {
    if ('undefined' !== typeof number) {
      var _filler = '';
      for (var i = 0; i < padding - 1; i++) {
        _filler += '0';
      }
      return (_filler + number.toString(16)).substr(-padding);
    }
    return '';
  }

  var View = function (view) {
    this.compression = ko.observable(view.compression);
    this.end = ko.observable(view.end);
    this.length = ko.observable(view.length);
    this.offset = ko.observable(view.offset);
    this.size = ko.observable(view.size);
  }

  function FileViewerModel(path, baseUrl) {
    var self = this;
    self.isLoading = ko.observable(true);
    self.showDownloadButton = ko.observable(false);
    self.currentPath = ko.observable(path);
    self.content = ko.observable('');
    self.currentMode = ko.observable('text');
    self.view = ko.observable();

    self.startPage = ko.observable(1);
    self.endPage = ko.observable(1);
    self.totalPages = ko.observable(1);

    self.firstPage = function () {

    }

    self.previousPage = function () {

    }

    self.nextPage = function () {

    }

    self.lastPage = function () {

    }

    self.switchMode = function () {
      if (self.currentMode() === 'text') {
        self.currentMode('binary');
      } else {
        self.currentMode('text');
      }
    }

    self.currentMode.subscribe(function () {
      self.getContent()
    });
    self.getContent = function (callback) {

      self.isLoading(true);

      $.getJSON(baseUrl, {
        length: 204800, // 50 pages
        mode: self.currentMode()
      }, function (data) {
        self.showDownloadButton(data.show_download_button);
        self.view = ko.mapping.fromJS(data.view);

        self.startPage((self.view.offset() / 4096) + 1);
        self.endPage(Math.ceil(self.view.end() / 4096));
        self.totalPages(Math.ceil(self.view.size() / 4096));

        if (data.view.contents) {
          self.content(data.view.contents);
        }
        if (data.view.xxd) {
          var _html = '';
          $(data.view.xxd).each(function (cnt, item) {
            var i;
            _html += '<tr><td>' + formatHex(item[0], 7) + ':&nbsp;</td><td>';

            for (i = 0; i < item[1].length; i++) {
              _html += formatHex(item[1][i][0], 2) + ' ' + formatHex(item[1][i][1], 2) + ' ';
            }

            _html += '</td><td>&nbsp;&nbsp;' + $('<span>').text(item[2]).html() + '</td></tr>';
          });

          self.content(_html);
        }
        if (callback) {
          callback();
        }

        self.isLoading(false);
      });
    }
  }

  return FileViewerModel;
})();
