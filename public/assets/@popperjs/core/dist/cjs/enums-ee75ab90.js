/**
 * @popperjs/core v2.11.8 - MIT License
 */

'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var top = 'top';
var bottom = 'bottom';
var right = 'right';
var left = 'left';
var auto = 'auto';
var basePlacements = [top, bottom, right, left];
var start = 'start';
var end = 'end';
var clippingParents = 'clippingParents';
var viewport = 'viewport';
var popper = 'popper';
var reference = 'reference';
var variationPlacements = /*#__PURE__*/basePlacements.reduce(function (acc, placement) {
  return acc.concat([placement + "-" + start, placement + "-" + end]);
}, []);
var placements = /*#__PURE__*/[].concat(basePlacements, [auto]).reduce(function (acc, placement) {
  return acc.concat([placement, placement + "-" + start, placement + "-" + end]);
}, []); // modifiers that need to read the DOM

var beforeRead = 'beforeRead';
var read = 'read';
var afterRead = 'afterRead'; // pure-logic modifiers

var beforeMain = 'beforeMain';
var main = 'main';
var afterMain = 'afterMain'; // modifier with the purpose to write to the DOM (or write into a framework state)

var beforeWrite = 'beforeWrite';
var write = 'write';
var afterWrite = 'afterWrite';
var modifierPhases = [beforeRead, read, afterRead, beforeMain, main, afterMain, beforeWrite, write, afterWrite];

exports.afterMain = afterMain;
exports.afterRead = afterRead;
exports.afterWrite = afterWrite;
exports.auto = auto;
exports.basePlacements = basePlacements;
exports.beforeMain = beforeMain;
exports.beforeRead = beforeRead;
exports.beforeWrite = beforeWrite;
exports.bottom = bottom;
exports.clippingParents = clippingParents;
exports.end = end;
exports.left = left;
exports.main = main;
exports.modifierPhases = modifierPhases;
exports.placements = placements;
exports.popper = popper;
exports.read = read;
exports.reference = reference;
exports.right = right;
exports.start = start;
exports.top = top;
exports.variationPlacements = variationPlacements;
exports.viewport = viewport;
exports.write = write;
//# sourceMappingURL=/assets/@popperjs/core/dist/cjs/enums-e6ac8e9b.js.map
