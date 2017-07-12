%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                             %
% This file is part of openLilyLib,                                           %
%                      ===========                                            %
% the community library project for GNU LilyPond                              %
% (https://github.com/openlilylib)                                            %
%              -----------                                                    %
%                                                                             %
% Package: breaks                                                             %
%          ======                                                             %
%                                                                             %
% openLilyLib is free software: you can redistribute it and/or modify         %
% it under the terms of the GNU General Public License as published by        %
% the Free Software Foundation, either version 3 of the License, or           %
% (at your option) any later version.                                         %
%                                                                             %
% openLilyLib is distributed in the hope that it will be useful,              %
% but WITHOUT ANY WARRANTY; without even the implied warranty of              %
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               %
% GNU General Public License for more details.                                %
%                                                                             %
% You should have received a copy of the GNU General Public License           %
% along with openLilyLib. If not, see <http://www.gnu.org/licenses/>.         %
%                                                                             %
% openLilyLib is maintained by Urs Liska, ul@openlilylib.org                  %
% and others.                                                                 %
%       Copyright Urs Liska, 2016                                             %
%                                                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Provide infrastructure for packages working with conditional line/page breaks
%

% Any functionality using breaks will rely on the edition-engraver
% which is also part of openLilyLib
%
\loadPackage edition-engraver

\consistToContexts #edition-engraver Score

% Install editionID
\layout {
  \context {
    \Score
    \editionID ##f breaks
  }
}

% Register a named set of breaks that can be used later.
% Calling \registerBreakSet <break-set> will initialize the break set
% to have *no* entries for line and page breaks or page turns. However,
% the break set can be *used* already.
% <break-set> is a name that will be globally visible. This is so it can
% be used from different packages. However, this means the user has to take
% care of providing unique names.
registerBreakSet =
#(define-void-function (break-set) (symbol?)
   (let ((base-path `(breaks break-sets ,break-set)))
     (setChildOption #t base-path 'line-breaks '())
     (setChildOption base-path 'page-breaks '())
     (setChildOption base-path 'page-turns '())))

% TODO:
% Should these two predicates be moved somewhere else?
#(define (edition-engraver-moment? obj)
   (or (integer? obj)
       (and (list? obj)
            (= 2 (length obj))
            (integer? (car obj))
            ; TODO
            ; This is probably a little bit fuzzy still ...
            (number? (cadr obj))
            )))
#(define (edition-engraver-list? obj)
   (every edition-engraver-moment? obj))

% Define *one* break set.
% #1: <break-set>
%     must be the name of a registered break set
% #2: <type>
%     must be one out of 'line-breaks 'page-breaks 'page-turns
% #3: <breaks>
%     a list of breaks. Each break can either be an integer
%     (referring to a bar number) or a two-element list with
%     an integer (bar number) and a fraction (zero-based moment).
% Example:
% \setConditionalBreaks original-edition line-breaks #'(4 8 (11 1/4) 15)
setBreaks =
#(define-void-function (break-set type breaks)
   (symbol? symbol? edition-engraver-list?)
   (setChildOption
    `(breaks break-sets ,break-set) type breaks))
