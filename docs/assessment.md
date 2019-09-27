---
layout: HubPage
hide_bc: true
author: david-stanford
ms.author: dastanfo
ms.date: 09-28-2019
ms.topic: hub-page
title: Assessment Building tool
description: Build assessments
---
<div ng-app="assessmentViewer" ng-controller="assessmentCtrl">        
        <div layout-padding ng-cloak>
            <md-toolbar>
                <div class="md-toolbar-tools">
                    <div flex md-truncate>
                        {{myData.title}}                    
                    </div>
                    <md-button class="md-raised" onclick="document.getElementById('file-input').click();">Load JSON</md-button>
                    <input id="file-input" type="file" name="name" file-change="loadExternal" style="display: none;" />
                    <md-button class="md-raised" ng-click="exportYaml()">Export to YAML</md-button>
                    <md-button class="md-raised" ng-click="saveChanges()">Save All Changes</md-button>
                </div>
            </md-toolbar>
            <section layout="row">
                <md-sidenav md-is-locked-open="true" md-whiteframe="4" ng-class="md-sidenav-left" ng-if="myData.category">
                    <md-toolbar class="md-hue-3" md-toolbar>
                        <h1 class="md-toolbar-tools">{{ catName }}</h1>
                    </md-toolbar>
                    <md-content>
                        <md-list>
                            <md-list-item class="md-2-line" ng-click="select($index)" ng-repeat="cat in myData.category">
                                <p>{{ cat.name }}</p>
                            </md-list-item>
                            <md-list-item class="md-2-line" ng-click="addCategory()"><p>+ Add Category</p></md-list-item>
                        </md-list>
                    </md-content>
                </md-sidenav>
                <md-content flex>
                    <div ng-if="question">
                        <md-content>
                            <md-toolbar class="md-hue-3" md-toolbar>
                                    <md-nav-bar
                                    md-selected-nav-item="currentNavItem"
                                    nav-bar-aria-label="navigation links">
                                    <md-nav-item ng-repeat="question in questions" md-nav-click="gotoQuestion($index)" name="page{{$index}}">
                                      Q{{$index}}
                                    </md-nav-item>
                                  </md-nav-bar>
                                <div class="md-toolbar-tools">
                                    <div layout="row" class="row" flex="100">
                                        <div ng-hide="edittitle" flex><br />{{question.title}}</div>
                                        <md-input-container ng-show="edittitle" flex>
                                                <input ng-model="question.title">
                                        </md-input-container>
                                        <md-switch ng-model="edittitle" >Edit</md-switch>                                    
                                    </div>
                                    <md-button class="md-raised" ng-click="addQuestion()">Add Question</md-button>
                                    <md-button class="md-raised" ng-click="nextQuestion()">Next Question</md-button>
                                </div>
                            </md-toolbar>
                            <md-content class="md-hue-1">
                                <div ng-repeat="choice in question.choices">
                                    <md-card>
                                        <md-list-item layout-padding layout="row" layout-wrap="">
                                        <div flex="grow">
                                                <span ><md-icon ng-bind="'check_box_outline_blank'"></md-icon>
                                                    <span ng-switch on="choice.priority">
                                                            <md-icon ng-bind="'arrow_upward'" ng-switch-when="high" style="color: red;" flex></md-icon>
                                                            <md-icon ng-bind="'more_horiz'" ng-switch-when="medium" style="color: orange;" flex></md-icon>
                                                            <md-icon ng-bind="'arrow_downward'" ng-switch-when="low" style="color: green;" flex></md-icon>
                                                            <md-icon ng-bind="'close'" ng-switch-default style="color: blue;" flex></md-icon>
                                                        {{choice.title}}
                                                        <md-button class="md-icon-button test-tooltip" aria-label="Info">
                                                            <md-tooltip ng-if="choice.answer_tooltip">{{choice.answer_tooltip}}</md-tooltip>
                                                            <md-icon ng-if="choice.answer_tooltip" ng-bind="'help_outline'" style="font-size: 16px; height: 12px;" flex></md-icon>
                                                        </md-button></span>
                                                    </span>  
                                                <p class="md-caption" flex="grow" >Tooltip: {{choice.answer_tooltip}}</p>
                                                <p class="md-caption" flex="grow" >Output: {{choice.output}}</p>
                                            </div>
                                            <md-switch aria-label="Toggle ngShow" ng-model="checked">Edit</md-switch>
                                        </md-list-item>
                                        <form name="editForm" layout-padding layout="row">
                                            <div class="flex flex-col" flex="100" ng-show="checked">
                                                <md-input-container class="md-block">
                                                    <label>Title:
                                                    </label>
                                                    <input ng-model="choice.title">
                                                </md-input-container>
                                                <md-input-container class="md-block">
                                                    <label>Tooltip:
                                                    </label>
                                                    <input ng-model="choice.answer_tooltip">
                                                </md-input-container>
                                                <md-input-container class="md-block">
                                                    <label>Output:
                                                    </label>
                                                    <input ng-model="choice.output">
                                                </md-input-container>
                                                <md-input-container class="md-block">
                                                    <label>Priority:
                                                    </label>
                                                    <md-select ng-model="choice.priority">
                                                        <md-option value="high">
                                                            High
                                                        </md-option>
                                                        <md-option value="medium">
                                                            Medium
                                                        </md-option>
                                                        <md-option value="low">
                                                            Low
                                                        </md-option>
                                                    </md-select>
                                                </md-input-container>
                                            </div>
                                        </form>
                                    </md-card>
                                </div>
                                <md-card><md-list-item class="md-2-line" ng-click="addChoice()"><p>+ Add Choice</p></md-list-item></md-card>
                            </md-content>
                        </div>
                    </md-content>
                </section>
            </div><!-- Vendor: Javascripts --><script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
            </script><!-- Vendor: Angular, followed by our custom Javascripts --><!-- Angular Material requires Angular.js Libraries --><script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.7.6/angular.min.js"></script>
            <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.7.6/angular-animate.min.js"></script>
            <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.7.6/angular-aria.min.js"></script>
            <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.7.6/angular-messages.min.js"></script><!-- Angular Material Library --><script src="https://ajax.googleapis.com/ajax/libs/angular_material/1.1.12/angular-material.min.js"></script>
            <!-- Our Website Javascripts -->
            <script src="js/main.js"></script>
        </body>
<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==" onload="var link = document.createElement('link');link.setAttribute('type', 'text/css');link.setAttribute('href', 'https://ajax.googleapis.com/ajax/libs/angular_material/1.1.12/angular-material.min.css');document.head.appendChild(link);var link1 = document.createElement('link');link1.setAttribute('type', 'text/css');link1.setAttribute('href', 'https://fonts.googleapis.com/icon?family=Material+Icons');document.head.appendChild(link1);var link2 = document.createElement('link');link2.setAttribute('type', 'text/css');link2.setAttribute('href', 'https://fonts.googleapis.com/css?family=Roboto:300,400,500,700,400italic');document.head.appendChild(link2);var script = document.createElement('script');script.setAttribute('type', 'text/javascript');script.setAttribute('src', 'https://ajax.googleapis.com/ajax/libs/angularjs/1.7.6/angular.min.js');document.head.appendChild(script);var script1 = document.createElement('script');script1.setAttribute('type', 'text/javascript');script1.setAttribute('src', 'https://ajax.googleapis.com/ajax/libs/angularjs/1.7.6/angular-animate.min.js');setTimeout(function() {document.head.appendChild(script1)},1000);var script2 = document.createElement('script');script2.setAttribute('type', 'text/javascript');script2.setAttribute('src', 'https://ajax.googleapis.com/ajax/libs/angularjs/1.7.6/angular-aria.min.js');setTimeout(function() {document.head.appendChild(script2)}, 1000);var script3 = document.createElement('script');script3.setAttribute('type', 'text/javascript');script3.setAttribute('src', 'https://ajax.googleapis.com/ajax/libs/angularjs/1.7.6/angular-messages.min.js');setTimeout(function() {document.head.appendChild(script3)}, 1000);setTimeout(function() { document.getElementById('scriptButton').click(); }, 1000);" />

<button id ='scriptButton' style="display: none;" onclick="var app = angular.module('assessmentViewer', ['ngMaterial', 'ngMessages']).config(function($mdThemingProvider) { $mdThemingProvider.theme('default').primaryPalette('light-blue') .accentPalette('red'); }); app.controller('assessmentCtrl', function ($scope, $http) { $scope.questionIndex = 0; $scope.catIndex = 0; $scope.myData = 'test'; $scope.select = function(index){ $scope.questionIndex = 0; $scope.catIndex = index; $scope.catName = $scope.myData.category[index].name; $scope.question = $scope.myData.category[index].questions[0]; }; $scope.nextQuestion = function(qIndex){ if ($scope.questionIndex + 1 < $scope.myData.category[$scope.catIndex].questions.length){ $scope.questionIndex++; $scope.question = $scope.myData.category[$scope.catIndex].questions[$scope.questionIndex]; } }; $scope.edit = function(index){ alert(JSON.stringify($scope.myData.category[$scope.catIndex].questions[$scope.questionIndex].choices[index])); }; $scope.addCategory = function(){ $scope.myData.category.push({'questions':[], 'name':'setMe'}); }; $scope.addQuestion = function(){ $scope.myData.category[$scope.catIndex].questions.push({'choices':[], 'title':'setMe', 'type':'checkbox'}); $scope.questionIndex = $scope.myData.category[$scope.catIndex].questions.length - 1; $scope.question = $scope.myData.category[$scope.catIndex].questions[$scope.questionIndex]; }; $scope.addChoice = function(){ $scope.myData.category[$scope.catIndex].questions[$scope.questionIndex].choices.push({'answer_tooltip':'','output':'', 'priority':'medium', 'title':'SetMe'}); }; $scope.saveChanges = function(){ saveData($scope.myData, 'assessment.json'); }; $scope.exportYaml = function(){ exportYML($scope.myData, $scope.myData.title.replace(' ', '-') + '.yml') }; $scope.loadExternal = function(){ console.log('external'); }; }); app.directive('fileChange', function () { return { restrict: 'A', link: function ($scope, el, attrs, ngModel) { el.bind('change', function (event) { console.log(event); var reader = new FileReader(); reader.readAsText(event.target.files[0], 'UTF-8'); reader.onload = function (evt) { var temp = evt.target.result; $scope.myData = JSON.parse(evt.target.result); }; reader.onerror = function (evt) { alert ('error reading file'); }; $scope.$apply(); }); } }; }); function isActive(state) { return this.$state.current.name.includes(state); }; function saveData(data, fileName) { var a = document.createElement('a'); document.body.appendChild(a); a.style = 'display: none'; var json = JSON.stringify(data, null, 2), blob = new Blob([json], {type: 'text/plain;charset=utf-8'}), url = window.URL.createObjectURL(blob); a.href = url; a.download = fileName; a.click(); window.URL.revokeObjectURL(url); }; function exportYML(data, fileName){ console.log('to be implemented'); }; console.log('test');" />