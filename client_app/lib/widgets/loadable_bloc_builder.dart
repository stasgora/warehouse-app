import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse_app/logic/reloadable/reloadable_cubit.dart';

class LoadableBlocBuilder<CubitType extends ReloadableCubit> extends StatelessWidget {
	final BlocWidgetBuilder<DataLoadSuccess> builder;
	final BlocWidgetBuilder<LoadableState> loadingBuilder;
	final bool wrapWithExpanded;

  LoadableBlocBuilder({this.builder, this.loadingBuilder, this.wrapWithExpanded = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitType, LoadableState>(
	    builder: (context, state) {
		    if (state is DataLoadInitial)
			    context.bloc<CubitType>().loadData();
		    else if (state is DataLoadSuccess)
			    return builder(context, state);
				if(loadingBuilder == null)
					return wrapWithExpanded ? Expanded(child: Center(child: CircularProgressIndicator())) : Center(child: CircularProgressIndicator());
				else return loadingBuilder(context, state);
	    }
    );
  }
}
