## -*- coding: utf-8 -*-
## Licensed to Cloudera, Inc. under one
## or more contributor license agreements.  See the NOTICE file
## distributed with this work for additional information
## regarding copyright ownership.  Cloudera, Inc. licenses this file
## to you under the Apache License, Version 2.0 (the
## "License"); you may not use this file except in compliance
## with the License.  You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
<%!
  import datetime
  from django.template.defaultfilters import urlencode, stringformat, date, filesizeformat, time
  from filebrowser.views import truncate
  from desktop.views import commonheader, commonfooter
  from django.utils.translation import ugettext as _
%>
<%
  path_enc = path
  dirname_enc = urlencode(view['dirname'])
  base_url = url('filebrowser.views.view', path=path_enc)
%>
<%namespace name="fb_components" file="fb_components.mako" />

## ${ commonheader(_('%(filename)s - File Viewer') % dict(filename=truncate(filename)), 'filebrowser', user, request) | n,unicode }
## ${ fb_components.menubar() }

<link href="${ static('filebrowser/css/fileviewer.css') }" rel="stylesheet" type="text/css">

<div id="fileViewer" class="file-viewer">

  <div class="top-bar">
    <h3 data-bind="text: currentPath" class="pull-left"></h3>

    <h3 class="pull-right">
      <!-- ko if: isLoading -->
      <i class="fa fa-spinner fa-spin margin-right-20"></i>
      <!-- /ko -->
      <!-- ko ifnot: isLoading -->
      <a href="#"><i class="fa fa-fw fa-refresh"></i></a>
      <!-- ko if: showDownloadButton -->
      <a href="#"><i class="fa fa-fw fa-download"></i></a>
      <!-- /ko -->
      <!-- ko if: currentMode() === 'text' -->
      <a class="pointer" data-bind="click: switchMode"><i class="fa fa-fw fa-th"></i></a>
      <!-- /ko -->
      <!-- ko if: currentMode() === 'binary' -->
      <a class="pointer" data-bind="click: switchMode"><i class="fa fa-fw fa-file-text-o"></i></a>
      <!-- /ko -->
      <a class="pointer" data-bind="click: function(){ huePubSub.publish('close.fileviewer') }"><i class="fa fa-fw fa-times"></i></a>
      <!-- /ko -->
    </h3>

  </div>

  <div class="file-area like-pre">
    <!-- ko if: isLoading -->
    <div class="center">
      <i class="fa fa-spinner fa-spin muted" style="font-size: 40px"></i>
    </div>
    <!-- /ko -->

    <!-- ko if: currentMode() === 'text' -->
    <pre data-bind="text: content" style="border-left: none"></pre>
    <!-- /ko -->

    <!-- ko if: currentMode() === 'binary' -->
    <table class="binary">
      <tbody data-bind="html: content">
      </tbody>
    </table>
    <!-- /ko -->
  </div>

  <!-- ko if: !isLoading() && (startPage() - endPage() < totalPages() - 1)  -->
  <div class="file-pagination">
    Pages <input data-bind="textInput: startPage" class="input-mini inline-block center"> to <input data-bind="textInput: endPage" class="input-mini inline-block center"> of <strong data-bind="text: totalPages"></strong>
    <ul class="inline">
      <li><a class="pointer" data-bind="click: firstPage, css: {'muted': startPage() === 1}" title="${ _('First page')}"><i class="fa fa-fast-backward"></i></a></li>
      <li><a class="pointer" data-bind="click: previousPage, css: {'muted': startPage() === 1}" title="${ _('Previous page')}"><i class="fa fa-backward"></i></a></li>
      <li><a class="pointer" data-bind="click: nextPage, css: {'muted': endPage() === totalPages()}" title="${ _('Next page')}"><i class="fa fa-forward"></i></a></li>
      <li><a class="pointer" data-bind="click: lastPage, css: {'muted': endPage() === totalPages()}" title="${ _('Last page')}"><i class="fa fa-fast-forward"></i></a></li>
    </ul>
  </div>
  <!-- /ko -->

</div>


<script src="${ static('filebrowser/js/fileviewer.ko.js') }"></script>
<script>

var vm = new FileViewerModel('${path_enc}', '${base_url}');
ko.applyBindings(vm, $('#fileViewer')[0]);
vm.getContent();

</script>

## ${ commonfooter(request, messages) | n,unicode }
