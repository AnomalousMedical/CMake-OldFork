/*============================================================================
  CMake - Cross Platform Makefile Generator
  Copyright 2000-2009 Kitware, Inc.

  Distributed under the OSI-approved BSD License (the "License");
  see accompanying file Copyright.txt for details.

  This software is distributed WITHOUT ANY WARRANTY; without even the
  implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the License for more information.
============================================================================*/

#ifndef cmParseDelphiCoverage_h
#define cmParseDelphiCoverage_h

#include "cmStandardIncludes.h"
#include "cmCTestCoverageHandler.h"


/** \class cmParseDelphiCoverage
 * \brief Parse Delphi coverage information
 *
 * This class is used to parse Delphi(Pascal) coverage information
 * generated by the Delphi-Code-Coverage tool
 *
 * https://code.google.com/p/delphi-code-coverage/
 */

class cmParseDelphiCoverage
  {
  public:
    cmParseDelphiCoverage(cmCTestCoverageHandlerContainer& cont,
        cmCTest* ctest);
    bool LoadCoverageData(const std::vector<std::string> files);
    bool ReadDelphiHTML(const char* file);
    // Read a single HTML file from output
    bool ReadHTMLFile(const char* f);


  protected:

    class HTMLParser;
    cmCTestCoverageHandlerContainer& Coverage;
    cmCTest* CTest;
  };
#endif
