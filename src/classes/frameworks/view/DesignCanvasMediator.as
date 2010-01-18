package classes.frameworks.view 
{
	import classes.core.DesignCanvas;
	import classes.core.History;
	import classes.core.MediaLink;
	import classes.event.MediaContainerEvent;
	import classes.frameworks.controller.commandtype.DesignCanvasCT;
	import classes.frameworks.controller.commandtype.LayerManagerCT;
	import classes.transform.TransformTool;
	import classes.transform.TransformToolEvent;
	
	import mx.events.DragEvent;
	
	import org.puremvc.as3.patterns.mediator.BaseMediator;
	
	import ui.Snapshot;

	/**
	 * @author Halley
	 */
	public class DesignCanvasMediator extends BaseMediator 
	{
		public static const NAME : String = "DesignCanvasMediator";

		public function DesignCanvasMediator( viewComponent : Object = null)
		{
			super( NAME, viewComponent );
			designCanvas = DesignCanvas( viewComponent );
			transformTool = designCanvas.transformTool;
			designCanvas.addEventListener( TransformToolEvent.TARGET_MATRIX_CHANGE, onMatrixChange );
			designCanvas.addEventListener( DragEvent.DRAG_DROP, onDragDrop );
			designCanvas.addEventListener( DragEvent.DRAG_DROP, onDragDrop,true );
		}

		private function onRemoveMediaObject(event : MediaContainerEvent) : void
		{
			sendNotification( LayerManagerCT.CMD_REMOVE_MEDIAOBJECT, event.link );
		}

		private function onSetSelection(event : TransformToolEvent) : void
		{
			sendNotification( DesignCanvasCT.CMD_SETSELECTION, event );
			//designCanvas.setSelection( event.uid, true, false );
		}

		/**
		 * 当有拖拽进入画布区域并放下时
		 * @param event
		 */
		private function onDragDrop(event : DragEvent) : void
		{
			var snapshot:Snapshot;
			if (event.dragInitiator is Snapshot)
			{
				snapshot = Snapshot( event.dragInitiator );
				var link:MediaLink = snapshot.mediaLink.clone();
				if(link.isBackground)
					facade.sendNotification( DesignCanvasCT.CMD_CHANGE_BACKGROUND, new History(designCanvas.background.mediaLink,link) );
				else if(link.isMask)
					facade.sendNotification( DesignCanvasCT.CMD_ADD_MASK, link );
				else				
					facade.sendNotification( DesignCanvasCT.CMD_ADD_MEDIAOBJECT, link );
			}
		}
		
		private function onMatrixChange(event : TransformToolEvent) : void
		{
			//trace( "DesignCanvasMediator onMatrixChange" );
			sendNotification( DesignCanvasCT.CMD_MATRIX_CHANGE, event );
		}
		/*
		override public function listNotificationInterests() : Array 
		{
			return [];            
		}

		override public function handleNotification( note : INotification ) : void 
		{
			switch ( note.getName( ) ) 
			{
			}
		}*/
	}
}