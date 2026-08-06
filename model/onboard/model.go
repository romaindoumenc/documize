// Copyright 2016 Documize Inc. <legal@documize.com>. All rights reserved.
//
// This software (Documize Community Edition) is licensed under
// GNU AGPL v3 http://www.gnu.org/licenses/agpl-3.0.en.html
//
// You can operate outside the AGPL restrictions by purchasing
// Documize Enterprise Edition and obtaining a commercial license
// by contacting <sales@documize.com>.
//
// https://documize.com

// Package onboarding handles the setup of sample data for a new Documize instance.
package onboard

import (
	"github.com/romaindoumenc/documize/domain"
	"github.com/romaindoumenc/documize/model/attachment"
	"github.com/romaindoumenc/documize/model/category"
	"github.com/romaindoumenc/documize/model/doc"
	"github.com/romaindoumenc/documize/model/label"
	"github.com/romaindoumenc/documize/model/link"
	"github.com/romaindoumenc/documize/model/page"
	"github.com/romaindoumenc/documize/model/space"
)

// SampleData holds initial welcome data used during installation process.
type SampleData struct {
	LoadFailure        bool // signals any data load failure
	Context            domain.RequestContext
	Category           []category.Category
	CategoryMember     []category.Member
	Document           []doc.Document
	DocumentAttachment []attachment.Attachment
	DocumentLink       []link.Link
	Section            []page.Page
	SectionMeta        []page.Meta
	Space              []space.Space
	SpaceLabel         []label.Label
}
