#tag Class
Protected Class OvalButton
Inherits Canvas
	#tag Event
		Function MouseDown(X As Integer, Y As Integer) As Boolean
		  dim result as HCMenu
		  
		  SetState kStatePressed
		  
		  if me.Type = kTypeMenuButton then
		    if MenuOnRight then
		      result = menu.Open(me.window.left + me.left + me.width + 4, me.window.top + me.top + 1, me.window)
		    else
		      menu.selectedItem = -1
		      result = menu.Open(me.window.left + me.left + 1, me.window.top + me.top + me.height + 6, me.window)
		    end if
		    
		    if result <> nil then
		      if CheckedMenu then
		        me.UpdateMenuMark()
		      end if
		      Action(result.Items(me.menu.SelectedItem))
		    end if
		  end if
		  
		  return true
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub MouseDrag(X As Integer, Y As Integer)
		  if X > -1 and X < me.width then
		    if Y > -1 and Y < self.height then
		      if not inControl then
		        inControl = true
		        SetState kStatePressed
		      end if
		    else
		      if inControl then
		        inControl = false
		        if myValue then
		          SetState kStatePressed
		        else
		          SetState kStateNormal
		        end if
		      end if
		    end if
		  else
		    if inControl then
		      inControl = false
		      if myValue then
		        SetState kStatePressed
		      else
		        SetState kStateNormal
		      end if
		    end if
		  end if
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseEnter()
		  if me.active then
		    inControl = true
		    'me.MouseCursor = System.Cursors.StandardPointer
		    SetState kStateRollover
		  end if
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseExit()
		  if self.active then
		    select case Type
		    case kTypePushButton, kTypeMenuButton
		      SetState kStateNormal
		    else
		      if myValue then
		        SetState kStatePressed
		      else
		        SetState kStateNormal
		      end if
		    end select
		  end if
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseUp(X As Integer, Y As Integer)
		  if inControl then
		    SetState kStateRollover
		    'SetState kStateNormal
		    if me.Type <> kTypeMenuButton then
		      if me.Type = kTypeStickyButton then
		        if not myValue then
		          myValue = true
		          Action(nil)
		        end if
		      elseif me.Type = kTypeToggleButton then
		        myValue = not myValue
		        Action(nil)
		      else
		        Action(nil)
		      end if
		    end if
		  end if
		End Sub
	#tag EndEvent

	#tag Event
		Sub Open()
		  
		  me.InitGraphics
		  
		  if me.Type = kTypeMenuButton then
		    me.menu = new HCMenu
		    me.menu.selectedItem = -1
		  end if
		  
		  Open()
		  
		  me.inited = true
		  me.Caption = myCaption
		  
		  if CheckedMenu then
		    me.UpdateMenuMark()
		  end if
		  
		  me.refresh
		End Sub
	#tag EndEvent

	#tag Event
		Sub Paint(g As Graphics)
		  Render g
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Shared Sub InitGraphics()
		  if not graphicsInited then
		    Arrow.mask.graphics.drawPicture ArrowMask, 0, 0
		    ArrowPress.mask.graphics.drawPicture ArrowPressMask, 0, 0
		    ArrowR.mask.graphics.drawPicture ArrowRMask, 0, 0
		    ArrowPressR.mask.graphics.drawPicture ArrowPressRMask, 0, 0
		    
		    CapPressL.mask.graphics.drawPicture CapPressLMask, 0, 0
		    MidPress.mask.graphics.drawPicture MidPressMask, 0, 0
		    CapPressR.mask.graphics.drawPicture CapPressRMask, 0, 0
		    
		    CapRollL.mask.graphics.drawPicture CapRollLMask, 0, 0
		    MidRoll.mask.graphics.drawPicture MidRollMask, 0, 0
		    CapRollR.mask.graphics.drawPicture CapRollRMask, 0, 0
		    
		    graphicsInited = true
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Render(g as graphics)
		  
		  // Render Background
		  if me.state = kStatePressed then
		    g.drawPicture CapPressL, 0, 0
		    g.drawPicture MidPress, 8, 0, me.width - 16, 17, 0, 0, MidPress.width, MidPress.height
		    g.drawPicture CapPressR, me.width - 8, 0
		  elseif me.state = kStateRollover then
		    g.drawPicture CapRollL, 0, 0
		    g.drawPicture MidRoll, 8, 0, me.width - 16, 17, 0, 0, MidRoll.width, MidRoll.height
		    g.drawPicture CapRollR, me.width - 8, 0
		  end if
		  
		  
		  // Render Caption
		  g.textFont = "SmallSystem"
		  g.textSize = 0
		  g.bold = true
		  
		  if me.state =  kStateNormal then
		    g.foreColor = kTextShadowColorNormal
		    g.drawString myCaption, 8, 8 + (g.textHeight / 3) + 1
		    g.foreColor = kTextColorNormal
		    g.drawString myCaption, 8, 8 + (g.textHeight / 3)
		  else
		    g.foreColor = kTextShadowColorPressed
		    g.drawString myCaption, 8, 8 + (g.textHeight / 3) + 1
		    g.foreColor = kTextColorPressed
		    g.drawString myCaption, 8, 8 + (g.textHeight / 3)
		  end if
		  
		  
		  // Render menu arrow (if needed)
		  if me.Type = kTypeMenuButton then
		    if MenuOnRight then
		      if state = kStateNormal then
		        self.graphics.drawPicture ArrowR, self.width - 12, 4
		      else
		        self.graphics.drawPicture ArrowPressR, self.width - 12, 4
		      end if
		    else
		      if state = kStateNormal then
		        self.graphics.drawPicture Arrow, self.width - 12, 6
		      else
		        self.graphics.drawPicture ArrowPress, self.width - 12, 6
		      end if
		    end if
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetState(s as integer)
		  me.state = s
		  me.refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UpdateMenuMark()
		  dim i as integer
		  
		  for i = 0 to ubound(me.menu.items)
		    if i = me.menu.selectedItem then
		      me.menu.items(i).checked = true
		    else
		      me.menu.items(i).checked = false
		    end if
		  next
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Action(menuItem as ConItem)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Open()
	#tag EndHook


	#tag Note, Name = Info
		
		OvalButton
		REALbasic custom control with many options to mimic the Apple Safari buttons used for bookmark bar.
		
		Copyright (c)2007-2010, Massimo Valle
		All rights reserved.
		
		this class make use of HierPop classes which are
		Copyright by Noah Desch <http://www.wireframesoftware.com/>
		
		Redistribution and use in source and binary forms, with or without modification,
		are permitted provided that the following conditions are met:
		- Redistributions of source code must retain the above copyright notice,
		this list of conditions and the following disclaimer.
		- Redistributions in binary form must reproduce the above copyright notice,
		this list of conditions and the following disclaimer in the documentation and/or
		other materials provided with the distribution.
		- Neither the name of the author nor the names of its contributors may be used to
		endorse or promote products derived from this software without specific prior written permission.
		
		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
		IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
		FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
		CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
		DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
		DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
		IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
		OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
	#tag EndNote


	#tag Property, Flags = &h0
		Align As integer = 0
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return myCaption
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  
			  dim p as picture
			  dim oldRight as integer
			  
			  myCaption = value
			  
			  if inited then
			    if not FixedSize then
			      oldRight = me.left+me.width-1
			      
			      p = newPicture(1,1,32)
			      p.graphics.TextFont = "SmallSystem"
			      p.graphics.TextSize = 0
			      p.graphics.Bold = true
			      me.width = p.graphics.StringWidth(myCaption)+16
			      if me.Type = kTypeMenuButton then
			        me.width = me.width + 7
			      end if
			      if me.Align = kAlignCenter then
			        me.left = me.left + ((oldRight-(me.left+me.width-1))\2)
			      elseif me.Align = kAlignRight then
			        me.left = me.left + (oldRight-(me.left+me.width-1))
			      end if
			    end if
			  end if
			End Set
		#tag EndSetter
		Caption As string
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		CheckedMenu As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		FixedSize As boolean = false
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared graphicsInited As boolean = false
	#tag EndProperty

	#tag Property, Flags = &h21
		Private inControl As boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private inited As boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private lastState As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		menu As HCMenu
	#tag EndProperty

	#tag Property, Flags = &h0
		MenuOnRight As boolean = false
	#tag EndProperty

	#tag Property, Flags = &h21
		Private myCaption As string
	#tag EndProperty

	#tag Property, Flags = &h21
		Private myValue As boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return myValue
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  myValue = value
			  if value then
			    SetState kStatePressed
			  else
			    SetState kStateNormal
			  end if
			End Set
		#tag EndSetter
		Selected As boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected State As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Type As Integer = 0
	#tag EndProperty


	#tag Constant, Name = kAlignCenter, Type = Double, Dynamic = False, Default = \"1", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kAlignLeft, Type = Double, Dynamic = False, Default = \"0", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kAlignRight, Type = Double, Dynamic = False, Default = \"2", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kStateNormal, Type = Double, Dynamic = False, Default = \"0", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kStatePressed, Type = Double, Dynamic = False, Default = \"1", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kStateRollover, Type = Double, Dynamic = False, Default = \"2", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kTextColorNormal, Type = Color, Dynamic = False, Default = \"&c262626", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kTextColorPressed, Type = Color, Dynamic = False, Default = \"&cFFFFFF", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kTextShadowColorNormal, Type = Color, Dynamic = False, Default = \"&cD8D8D8", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kTextShadowColorPressed, Type = Color, Dynamic = False, Default = \"&c262626", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kTypeMenuButton, Type = Double, Dynamic = False, Default = \"3", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kTypePushButton, Type = Double, Dynamic = False, Default = \"0", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kTypeStickyButton, Type = Double, Dynamic = False, Default = \"1", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kTypeToggleButton, Type = Double, Dynamic = False, Default = \"2", Scope = Protected
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="AcceptFocus"
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AcceptTabs"
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Align"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			EditorType="Enum"
			#tag EnumValues
				"0 - Left"
				"1 - Center"
				"2 - Right"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="AutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Backdrop"
			Group="Appearance"
			Type="Picture"
			EditorType="Picture"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Caption"
			Visible=true
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CheckedMenu"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DoubleBuffer"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EraseBackground"
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FixedSize"
			Visible=true
			Group="Behavior"
			InitialValue="false"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="17"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HelpTag"
			Visible=true
			Group="Appearance"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="InitialParent"
			Group="Behavior"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MenuOnRight"
			Visible=true
			Group="Behavior"
			InitialValue="false"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Selected"
			Visible=true
			Group="Behavior"
			InitialValue="false"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Group="Position"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Type"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType="Enum"
			#tag EnumValues
				"0 - PushButton"
				"1 - StickyButton"
				"2 - ToggleButton"
				"3 - MenuButton"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="UseFocusRing"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
